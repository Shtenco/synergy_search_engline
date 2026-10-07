# 09. TEST RESULTS

## Internal 30% fork

При fee=0.3%:

\[
Mint/InternalReserve\approx14.0386\%
\]

\[
CanonicalExtraction\approx12.2780\%
\]

Внутренний QE перераспределяет canonical между LP и treasury, но сам не создаёт aggregate HardNAV.

## 10 USDT 9-pool controlled model

При 30% fork:

- LP canonical NAV: 8.7722
- treasury canonical NAV: 1.2278
- total: 10.0

## Finite CPMM external synthetic triangle

При independent synthetic ~30% external edge finite-depth CPMM показал positive canonical alpha; при росте routed size edge снижался из-за slippage.

## Self-induced roundtrip

Тест подтвердил отрицательный PnL после fees/slippage.

## V2.1 HardNAV multiplier

Capacity=5x baseline:

- 10 cycles: 1.212273x
- 100 cycles: 6.239175x
- 1000 cycles: 87.396675x

## Dividend tests

Terminal cash-out keep $1:

- 10: 0.212273x dividends
- 100: 5.239175x
- 1000: 86.396675x

Sustainable target:

\[
H^*\approx5.35
\]

\[
DividendPerCycle\approx0.090175
\]

1000 cycles:

\[
CumulativeDividends\approx82.046675
\]

при residual HardNAV ≈ 5.35.

## Интерпретация

Все значения выше — simulated/modelled. Они подтверждают accounting logic и sensitivity к capacity, но не доказывают наличие таких opportunities на реальном Polygon.
