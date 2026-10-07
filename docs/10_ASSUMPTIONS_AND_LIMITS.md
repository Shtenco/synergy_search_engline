# 10. ASSUMPTIONS AND LIMITS

## Критические assumptions

1. Independent external edge существует.
2. Edge имеет конечную capacity.
3. Capacity может повторяться во времени.
4. Costs моделируются корректно.
5. Reinvestment не меняет рынок сильнее, чем учтено slippage model.
6. Canonical assets ликвидны.
7. Price oracle не манипулируется внутренними токенами.

## Что может завышать multiplier

- постоянный edge;
- постоянная capacity;
- отсутствие конкурентов;
- слишком низкий MEV;
- слишком низкий gas;
- отсутствие latency;
- отсутствие failed transactions;
- отсутствие bridge risk;
- отсутствие inventory imbalance;
- отсутствие adverse selection.

## Что обязательно добавить

- stochastic edge process;
- edge half-life;
- capacity decay;
- competition;
- missed fills;
- gas volatility;
- MEV distribution;
- drawdown;
- tail shocks;
- bridge delays;
- canonical price risk;
- multi-asset inventory risk.

## Научная маркировка

Каждая цифра должна иметь label:

- measured;
- simulated;
- theoretical;
- backtested;
- fork-tested;
- live-tested.

До настоящего Polygon fork текущие multipliers — simulated.
