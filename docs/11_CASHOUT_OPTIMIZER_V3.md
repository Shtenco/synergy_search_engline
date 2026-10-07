# 11. CASH-OUT OPTIMIZER V3

## Задача

После V2.1 цель была изменена с простого максимума HardNAV на многокритериальную:

\[
\max
\left(
M_D,\;
DividendRate,\;
ResidualHardNAV
\right)
\]

где:

\[
M_D=
\frac{CumulativeCanonicalDividends}
{ExternalDollarIn}
\]

## Политика

Оптимизатор перебирает:

- target working HardNAV;
- долю reinvestment до target;
- payout fraction после target;
- горизонты 100 и 1000 циклов.

Baseline external assumptions остаются V2.1:

- initial external capital = 1.0;
- independent gross edge = 3%;
- capacity = 5x initial/cycle;
- base utilization = 90%;
- QE effective utilization = 93.5%;
- external fee flow = 0.1%/cycle;
- bridge spread = 0.5%;
- finite slippage;
- fees/gas/MEV deducted.

## 100 циклов

### MAX M_D

Оптимальная политика:

- target_H = 2.25
- build reinvest = 100%
- payout after target = 100%

Результат:

\[
M_D = 2.473943
\]

\[
DividendRate_{tail}\approx0.024739/cycle
\]

\[
ResidualHardNAV=2.25
\]

\[
TotalGeneratedValue=4.723943
\]

### BALANCED

- target_H = 2.75
- build reinvest = 100%
- payout after target = 100%

\[
M_D=2.434353
\]

\[
ResidualHardNAV=2.75
\]

\[
TotalGeneratedValue=5.184353
\]

То есть на коротком горизонте возникает компромисс между большим cash-out и большим residual working capital.

## 1000 циклов

### MAX M_D

Оптимальная найденная политика:

- target_H = 5.50
- build reinvest = 100%
- payout after target = 100%

\[
M_D=81.896675
\]

\[
DividendRate_{tail}=0.090175/cycle
\]

\[
ResidualHardNAV=5.50
\]

\[
TotalGeneratedValue=87.396675
\]

### MAX DIVIDEND RATE

Та же steady dividend-rate достигается и при более медленном build, но cumulative dividend ниже:

- target_H = 5.50
- build reinvest = 50%
- payout after target = 100%
- M_D = 78.187328
- final H = 5.50

Следовательно, если horizon длинный и objective включает cumulative dividends, выгоднее **максимально быстро реинвестировать до saturation working capital**, затем переключиться на полный cash-out новой alpha.

## Главный результат

Для текущего baseline политика принимает вид:

\[
\boxed{
\text{BUILD HARDNAV FAST}
\rightarrow
H^*
\rightarrow
\text{PAY 100% NEW ALPHA}
}
\]

где grid-search дал:

\[
H^*\approx5.5
\]

(предыдущий continuous scan давал около 5.35; расхождение связано с шагом grid 0.25).

## Экономический смысл

До \(H^*\) дополнительный working capital увеличивает routed profitable volume.

После \(H^*\) opportunity capacity насыщается, поэтому marginal return от дополнительного retention резко падает.

Тогда optimal dividend governor должен:

1. оценивать текущую external capacity;
2. вычислять target working capital;
3. направлять максимум прибыли в reinvestment, пока \(H<H^*\);
4. после saturation выплачивать excess canonical alpha;
5. пересчитывать \(H^*\), если capacity/edge меняются.

## Следующая версия

V4 должна заменить фиксированные edge/capacity на stochastic process:

\[
Edge_t,\ Capacity_t,\ Gas_t,\ MEV_t
\]

и оптимизировать policy уже по распределению исходов, а не по одному deterministic baseline.
