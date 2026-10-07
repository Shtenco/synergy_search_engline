# 00. ОБЗОР СИСТЕМЫ

## Назначение

SYNERGY HardNAV Multiplier — исследовательская архитектура закрытой экономики с внутренней эмиссией и внешними источниками canonical-value.

Система разделяет три слоя:

1. **Internal money layer** — SYNA/SYNR/SUSD.
2. **Canonical balance-sheet layer** — WETH/WPOL/USDC.
3. **External alpha layer** — CrossDEX, bridge spread, external fee flow, independent price dislocations.

Главное правило:

\[
InternalMint \notin HardNAV
\]

## Поток одного цикла

\`\`\`text
External Canonical Principal
        |
        v
Canonical Treasury
        |
        +----> Reserve
        |
        v
QE Router / 9 Internal LP
        |
        v
WETH / WPOL / USDC inventory
        |
        +----> CrossDEX
        +----> Bridge inventory
        +----> External AMM / fee flow
        |
        v
Realized canonical alpha
        |
        +----> Reinvestment
        +----> LP replenishment
        +----> Dividend cash-out
        |
        v
Residual internal money -> burn
\`\`\`

## Почему система не считает mint прибылью

Если система mint'ит SYNA и меняет её на canonical внутри собственного system-owned LP, aggregate canonical units просто перераспределяются между LP и treasury.

Поэтому:

\[
HardNAV_{before}=HardNAV_{after}
\]

если не было внешнего canonical inflow, независимой market alpha или внешней переоценки.

## Целевые метрики

### HardNAV multiplier

\[
M_H = HardNAV / ExternalNetDeposits
\]

### Dividend multiplier

\[
M_D = CumulativeCanonicalDividends / ExternalDollarIn
\]

### Residual capital

\[
H_R = ResidualHardNAV
\]

### Многокритериальная цель

\[
\max (M_D,\ DividendRate,\ H_R)
\]

при ограничениях по ликвидности, slippage, fees, gas, MEV и drawdown.

## Polygon canonical graph

Для Polygon:

- WETH
- WPOL
- USDC

Внешний triangle:

\[
WETH \leftrightarrow WPOL \leftrightarrow USDC \leftrightarrow WETH
\]

Внутренний graph содержит 9 пар: каждая из SYNA/SYNR/SUSD против каждого canonical asset.

## Что должна доказать система

1. Mint не создаёт фиктивный HardNAV.
2. External alpha можно атрибутировать.
3. Canonical dividends реально cash-out'ятся.
4. Working HardNAV после dividend не падает ниже floor.
5. Opportunity capacity конечна.
6. При отсутствии edge governor выбирает NO_TRADE.
