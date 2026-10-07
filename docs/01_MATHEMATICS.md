# 01. МАТЕМАТИКА

## CPMM

Для пула \(x\cdot y=k\), input \(m\), fee \(f\), \(\gamma=1-f\):

\[
q_y = \frac{y\gamma m}{x+\gamma m}
\]

После swap:

\[
x'=x+m,\qquad y'=y-q_y
\]

## Внутренняя ценовая вилка

При normalized reserve \(z=m/x\):

\[
R=(1+z)(1+\gamma z)
\]

где \(R=P_1/P_0\).

Отсюда:

\[
z=
\frac{-(1+\gamma)+\sqrt{(1+\gamma)^2+4\gamma(R-1)}}{2\gamma}
\]

Canonical extraction fraction:

\[
e(z)=\frac{\gamma z}{1+\gamma z}
\]

Для 30% internal fork при fee=0.3%:

\[
R=1.30,\quad z\approx0.140386
\]

\[
e\approx0.12277998
\]

То есть internal mint около 14.04% внутреннего reserve высвобождает около 12.28% canonical-side reserve в treasury.

## Почему это не прибыль

Пусть до операции canonical side равен \(Y\).

После internal swap:

\[
LP=Y-q,\qquad Treasury=q
\]

Тогда:

\[
LP+Treasury=Y
\]

Следовательно mint лишь меняет расположение canonical inventory.

## External alpha

Пусть routed canonical capital \(Q\), gross edge \(E_g\), costs \(C\).

\[
E_n = \max(E_g-C,0)
\]

\[
\Pi = Q E_n
\]

В V2.1:

\[
Q_t = \min(H_t U_t,\ Capacity_t)
\]

Slippage моделируется как функция загрузки:

\[
S_t = k_s \left(\frac{Q_t}{Capacity_t}\right)^2
\]

И:

\[
E_{DEX}^{net}
=
\max(E_g-fee-gas-MEV-S_t,0)
\]

## Bridge alpha

\[
E_{bridge}^{net}
=
\max(Spread-BridgeFee-Gas,0)
\]

## HardNAV recursion

\[
H_{t+1}=H_t+\rho_t\Pi_t
\]

где \(\rho_t\) — reinvest fraction.

Canonical dividend:

\[
D_t=(1-\rho_t)\Pi_t
\]

Cumulative:

\[
D^{cum}_T=\sum_{t=1}^{T}D_t
\]

## Dividend multiplier

\[
M_D(T)=\frac{D^{cum}_T}{ExternalDollarIn}
\]

## Residual constraint

\[
H_T\ge H_{floor}
\]

Именно этот constraint отличает устойчивую dividend policy от полной ликвидации excess.

## Saturation working capital

Если opportunity capacity ограничена, существует рабочая область, после которой новый HardNAV перестаёт заметно увеличивать доступный profitable routed volume.

Ищем:

\[
H^*=\arg\max_H \Pi(H)
\]

После достижения \(H^*\) рационально уменьшать reinvestment и увеличивать dividend payout.
