# 04. EXTERNAL ALPHA ENGINES

## 1. CrossDEX Arbitrage

Используется только independent price difference.

\[
E_{net}=E_{gross}-DEXFees-Gas-MEV-Slippage
\]

Trade выполняется только если:

\[
E_{net}>E_{min}
\]

Self-induced mispricing не считается независимым edge.

## 2. Inventory Bridge

Bridge inventory поддерживает canonical reserves по обе стороны маршрута.

Доход:

\[
\Pi_{bridge}
=
RoutedCapital
\cdot
(Spread-BridgeFee-Gas-Slippage)
\]

Важный риск — inventory imbalance.

## 3. External Fee Harvest

Если system-owned liquidity обслуживает внешний order flow:

\[
FeeIncome = ExternalVolume\cdot FeeShare
\]

Это один из наиболее чистых external value sources, поскольку источник — чужой торговый volume.

## 4. Independent price dislocation

Например:

- DEX A vs DEX B;
- stale pool vs fresh market;
- cross-chain inventory;
- bridge delay;
- временно несинхронные рынки.

## Opportunity capacity

Любой edge имеет конечную profitable capacity:

\[
Q\le Capacity
\]

После этого slippage/impact съедает edge.

## NO_TRADE

Governor обязан выбирать NO_TRADE, если:

\[
ExpectedNetAlpha\le0
\]

Это ключевой защитный invariant.

## Attribution

Каждый alpha engine должен отчётно показывать:

\[
GrossPnL,\ Fees,\ Gas,\ Slippage,\ MEV,\ NetPnL
\]

и конечные canonical units.
