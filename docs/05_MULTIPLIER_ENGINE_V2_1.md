# 05. HARDNAV MULTIPLIER ENGINE V2.1

## Objective

\[
M_H=\frac{HardNAV}{ExternalNetDeposits}
\]

## Почему V2 unlimited недостаточна

Если предположить постоянный процентный edge без ограничения capacity, compound может дать астрономический multiplier.

Это математический upper bound, но не реалистичный execution model.

## V2.1

Введена finite capacity:

\[
Q_t=\min(H_tU_t,Capacity)
\]

и nonlinear slippage:

\[
S=k(Q/Capacity)^2
\]

## Baseline assumptions

- deposit: 1
- gross dex edge: 3%
- base utilization: 90%
- QE gain: 35%
- effective utilization: 93.5%
- external fee flow: 0.1%/cycle
- bridge spread: 0.5%
- DEX fee: 0.3%
- bridge fee: 0.08%
- gas proxy: 0.015%
- MEV proxy: 0.025%
- capacity: 5x initial/cycle

## Baseline results

\[
M_H(10)=1.212273
\]

\[
M_H(100)=6.239175
\]

\[
M_H(1000)=87.396675
\]

## Capacity sensitivity

При прочих равных примерно:

- 0.10x capacity -> 2.8035x на 1000 циклах
- 0.25x -> 5.50875x
- 0.50x -> 10.0175x
- 1.00x -> 19.033077x
- 2.00x -> 36.688714x
- 5.00x -> 87.396675x
- 10.00x -> 168.319474x

Это показывает, что главный рычаг — не mint, а доступная independent profitable capacity.
