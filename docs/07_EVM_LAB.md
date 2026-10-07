# 07. EVM LAB

## Цель

Перенести accounting и CPMM state transitions в Solidity и проверить invariants на настоящем EVM bytecode.

## Контрактный baseline

AbundanceLab содержит:

- Tok enum;
- Pool struct;
- addPool;
- quote;
- swap;
- mintInternal;
- burnResidual;
- canonicalTreasuryNAV;
- systemLPHardNAV;
- hardNAV;
- triangle;
- controlled external-value injection для unit-тестов.

## Контрольные сценарии

### CLOSED_INTERNAL_QE

Mint internal token и swap против system-owned canonical LP.

Ожидание:

\[
\Delta HardNAV=0
\]

кроме costs/rounding.

### EXTERNAL_FEE_INFLOW

Inject controlled canonical fee income.

Ожидание:

\[
\Delta HardNAV=ExternalValue
\]

### INDEPENDENT_TRIANGLE_EDGE

Создаётся независимый mispriced external triangle.

Ожидание:

\[
CanonicalOut>CanonicalIn
\]

после costs.

### SELF_INDUCED_ROUNDTRIP

Swap туда и обратно в одном market без внешнего edge.

Ожидание:

\[
CanonicalOut<CanonicalIn
\]

## Invariants

- reserves > 0;
- no hidden mint of canonical;
- internal mint excluded from HardNAV;
- dividend cannot exceed canonical treasury;
- accounting balance;
- NO_TRADE when net edge <= 0.

## Статус

Browser Remix automation была предпринята, но execution не дошёл до compile/deploy из-за UI timeout. Поэтому настоящий EVM PASS ещё не заявляется.

Следующий обязательный шаг — Foundry/Anvil.
