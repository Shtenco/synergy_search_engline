// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AbundanceLab {
    uint256 public constant ONE = 1e18;
    uint256 public constant BPS = 10_000;

    enum Tok { SYNA, SYNR, SUSD, WETH, WPOL, USDC }

    struct Pool {
        Tok a;
        Tok b;
        uint256 ra;
        uint256 rb;
        uint256 feeBps;
        bool systemOwned;
    }

    mapping(uint256 => Pool) public pools;
    uint256 public poolCount;

    mapping(Tok => uint256) public treasury;
    mapping(Tok => uint256) public supply;
    mapping(Tok => uint256) public priceUSDC;

    uint256 public realizedExternalAlphaUSDC;
    uint256 public cumulativeDividendsUSDC;

    event PoolAdded(uint256 indexed id, Tok a, Tok b, uint256 ra, uint256 rb, uint256 feeBps, bool systemOwned);
    event Minted(Tok indexed token, uint256 amount);
    event Burned(Tok indexed token, uint256 amount);
    event Swap(uint256 indexed poolId, Tok tokenIn, uint256 amountIn, Tok tokenOut, uint256 amountOut);
    event ExternalValueInjected(Tok indexed token, uint256 amount, uint256 usdcValue);
    event DividendPaid(Tok indexed token, uint256 amount, uint256 usdcValue);

    constructor() {
        priceUSDC[Tok.USDC] = ONE;
        priceUSDC[Tok.WETH] = 2700 * ONE;
        priceUSDC[Tok.WPOL] = 1172e14;
    }

    function setPrice(Tok t, uint256 p) external {
        require(_isCanonical(t), "canonical only");
        priceUSDC[t] = p;
    }

    function addPool(
        Tok a,
        Tok b,
        uint256 ra,
        uint256 rb,
        uint256 feeBps,
        bool systemOwned
    ) external returns (uint256 id) {
        require(a != b && ra > 0 && rb > 0, "bad pool");
        require(feeBps < BPS, "bad fee");
        id = poolCount++;
        pools[id] = Pool(a, b, ra, rb, feeBps, systemOwned);
        emit PoolAdded(id, a, b, ra, rb, feeBps, systemOwned);
    }

    function mintInternal(Tok t, uint256 amount) external {
        require(_isInternal(t), "internal only");
        supply[t] += amount;
        treasury[t] += amount;
        emit Minted(t, amount);
    }

    function burnResidual(Tok t) external returns (uint256 amount) {
        require(_isInternal(t), "internal only");
        amount = treasury[t];
        treasury[t] = 0;
        supply[t] -= amount;
        emit Burned(t, amount);
    }

    function quote(
        uint256 poolId,
        Tok tokenIn,
        uint256 amountIn
    ) public view returns (Tok tokenOut, uint256 amountOut) {
        Pool storage p = pools[poolId];
        require(amountIn > 0, "zero");
        uint256 gamma = BPS - p.feeBps;
        uint256 dxEff = amountIn * gamma;

        if (tokenIn == p.a) {
            tokenOut = p.b;
            amountOut = (p.rb * dxEff) / (p.ra * BPS + dxEff);
        } else if (tokenIn == p.b) {
            tokenOut = p.a;
            amountOut = (p.ra * dxEff) / (p.rb * BPS + dxEff);
        } else {
            revert("not in pool");
        }
    }

    function swap(
        uint256 poolId,
        Tok tokenIn,
        uint256 amountIn
    ) public returns (Tok tokenOut, uint256 amountOut) {
        require(treasury[tokenIn] >= amountIn, "treasury balance");
        Pool storage p = pools[poolId];

        (tokenOut, amountOut) = quote(poolId, tokenIn, amountIn);

        treasury[tokenIn] -= amountIn;
        treasury[tokenOut] += amountOut;

        if (tokenIn == p.a) {
            p.ra += amountIn;
            p.rb -= amountOut;
        } else {
            p.rb += amountIn;
            p.ra -= amountOut;
        }

        emit Swap(poolId, tokenIn, amountIn, tokenOut, amountOut);
    }

    function injectExternalValue(Tok canonical, uint256 amount) external {
        require(_isCanonical(canonical), "canonical only");
        treasury[canonical] += amount;
        uint256 v = _canonicalValue(canonical, amount);
        realizedExternalAlphaUSDC += v;
        emit ExternalValueInjected(canonical, amount, v);
    }

    function payDividend(Tok canonical, uint256 amount) external {
        require(_isCanonical(canonical), "canonical only");
        require(treasury[canonical] >= amount, "insufficient canonical");
        treasury[canonical] -= amount;
        uint256 v = _canonicalValue(canonical, amount);
        cumulativeDividendsUSDC += v;
        emit DividendPaid(canonical, amount, v);
    }

    function canonicalTreasuryNAV() public view returns (uint256 nav) {
        nav += _canonicalValue(Tok.WETH, treasury[Tok.WETH]);
        nav += _canonicalValue(Tok.WPOL, treasury[Tok.WPOL]);
        nav += _canonicalValue(Tok.USDC, treasury[Tok.USDC]);
    }

    function systemLPHardNAV() public view returns (uint256 nav) {
        for (uint256 i = 0; i < poolCount; i++) {
            Pool storage p = pools[i];
            if (!p.systemOwned) continue;
            nav += _canonicalValue(p.a, p.ra);
            nav += _canonicalValue(p.b, p.rb);
        }
    }

    function hardNAV() external view returns (uint256) {
        return canonicalTreasuryNAV() + systemLPHardNAV();
    }

    function triangle(
        uint256 p0,
        uint256 p1,
        uint256 p2,
        Tok start,
        uint256 amountIn
    ) external returns (uint256 amountOut) {
        (Tok t1, uint256 q1) = swap(p0, start, amountIn);
        (Tok t2, uint256 q2) = swap(p1, t1, q1);
        (Tok t3, uint256 q3) = swap(p2, t2, q2);
        require(t3 == start, "not closed");
        amountOut = q3;
    }

    function _canonicalValue(Tok t, uint256 amount) internal view returns (uint256) {
        if (!_isCanonical(t)) return 0;
        return amount * priceUSDC[t] / ONE;
    }

    function _isCanonical(Tok t) internal pure returns (bool) {
        return t == Tok.WETH || t == Tok.WPOL || t == Tok.USDC;
    }

    function _isInternal(Tok t) internal pure returns (bool) {
        return t == Tok.SYNA || t == Tok.SYNR || t == Tok.SUSD;
    }
}
