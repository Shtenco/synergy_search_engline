# 02. ТРЕУГОЛЬНАЯ ЭМИССИЯ БЕЗ ИНФЛЯЦИОННОГО САМООБМАНА

## Историческая модель

Базовый triangle:

\[
SYNA/USDT,\quad SYNR/USDT,\quad SYNA/SYNR
\]

Structural deviation:

\[
\delta=p_{AU}\cdot p_{AR}\cdot p_{RU}-1
\]

Контроллер использовал mint/burn не как источник wealth, а как способ управлять geometry triangle.

## Почему closed-only версия не создаёт богатство

Если все активы и все LP принадлежат системе, swap-прибыль одного внутреннего участника является изменением распределения внутри aggregate balance sheet.

При отсутствии external inflow:

\[
\Delta HardNAV\le 0
\]

после fees/gas.

## Правильная роль эмиссии

\[
Emission = LiquidityGeometryController
\]

Контроллер может:

- увеличивать/decrease internal supply;
- менять depth;
- управлять structural delta;
- повышать routed utilization;
- компенсировать imbalance;
- управлять LP replenishment.

## Mint/Burn

\[
Supply_{t+1}=Supply_t+Mint_t-Burn_t
\]

Цель supply controller:

\[
E[Mint-Burn]\approx0
\]

на длинном горизонте, если требуется нейтральная net issuance.

## Dynamic beta

Owner/dividend take не должен быть фиксированным.

\[
DividendTake_t=\beta_t\Pi_t
\]

\(\beta_t\) зависит от:

- HardNAV;
- reserve floor;
- LP depth;
- external edge;
- capacity utilization;
- stress state;
- drawdown.

## Depth guards

Базовые исследовательские thresholds:

\[
D_{high}=1.35,\qquad D_{low}=0.72
\]

При выходе за границы governor усиливает rebalance/replenishment и ограничивает payout.

## Ключевой вывод

Треугольная эмиссия становится экономически полезной только когда internal geometry помогает захватывать **внешний** поток canonical-value.
