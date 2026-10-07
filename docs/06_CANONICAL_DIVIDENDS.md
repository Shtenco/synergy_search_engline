# 06. CANONICAL DIVIDENDS

## Цель

Проверить, какая часть multiplier реально может быть конвертирована в canonical payout.

\[
M_D=
\frac{CumulativeCanonicalDividends}
{ExternalDollarIn}
\]

## Terminal cash-out

Политика:

1. reinvest до горизонта T;
2. в конце оставить residual floor;
3. весь excess выплатить canonical.

При floor=$1 и capacity=5x:

- T=10: dividends = 0.212273x
- T=100: dividends = 5.239175x
- T=1000: dividends = 86.396675x

## Sustainable cash-out

Ищется working capital \(H^*\), где marginal benefit дополнительного HardNAV становится мал.

Baseline:

\[
H^*\approx5.35
\]

После насыщения:

\[
DividendPerCycle\approx0.090175
\]

на исходный $1.

На 1000 циклах modeled:

\[
ResidualHardNAV\approx5.35
\]

\[
CumulativeDividends\approx82.046675
\]

## Почему это сильнее terminal cash-out

Terminal policy максимизирует payout на конкретном горизонте.

Sustainable policy сохраняет working engine и продолжает генерировать cash flow после горизонта.

## Следующий governor

Нужна динамическая политика:

\[
\rho_t = f(H_t,Capacity_t,Edge_t,Stress_t)
\]

где \(\rho_t\) — reinvest fraction.

Dividend:

\[
D_t=(1-\rho_t)\Pi_t
\]

Оптимизация:

\[
\max_\pi
\left[
M_D,\
DividendRate,\
ResidualHardNAV
\right]
\]
