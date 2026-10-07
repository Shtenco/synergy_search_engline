# 08. POLYGON MAINNET FORK PLAN

## Цель

Проверить систему на fixed Polygon Mainnet state без broadcast в реальную сеть.

## Canonical assets

- WETH
- WPOL
- USDC

## External graph

\[
WETH/WPOL,\quad WPOL/USDC,\quad WETH/USDC
\]

## Что читать с chain

- addresses;
- decimals;
- pool fee tiers;
- slot0;
- liquidity;
- ticks;
- Quoter output;
- gas estimates.

## Fork procedure

1. выбрать фиксированный block;
2. fork Polygon;
3. snapshot;
4. seed system treasury controlled $10 equivalent;
5. deploy SYNA/SYNR/SUSD + internal pools;
6. execute QE routing;
7. query external routes;
8. разрешить trade только при positive net edge;
9. settle canonical;
10. compute HardNAV;
11. execute dividend policy;
12. snapshot final state;
13. revert;
14. repeat across grid.

## Strong PASS

Нужен реальный executable result:

\[
ResidualHardNAV+CumulativeDividends
>
InitialExternalDeposits
\]

после fees/gas/slippage.

## Запрет

Fork test не должен считать чужой LP principal собственной прибылью. Profit считается только как изменение собственных canonical balances после полного закрытия маршрута.
