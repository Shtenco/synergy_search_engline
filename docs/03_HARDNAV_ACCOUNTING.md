# 03. HARDNAV ACCOUNTING

## Что входит

\[
HardNAV =
TreasuryCanonicalNAV +
SystemOwnedCanonicalLPNAV
\]

Canonical:

- WETH
- WPOL
- USDC

## Что не входит

- SYNA mark price
- SYNR mark price
- SUSD mark price
- внутренний TVL, созданный собственным mint
- нереализованные внутренние переоценки
- self-induced external mark distortion

## Treasury NAV

\[
NAV_T=\sum_c Units_c P_c
\]

## LP canonical NAV

Для system-owned pool internal/canonical учитывается только canonical side:

\[
NAV_{LP}=\sum_i Y_iP_i
\]

Internal token reserve \(X_i\) не добавляется к HardNAV.

## External alpha ledger

Каждый profit event должен иметь provenance:

- route;
- canonical asset;
- amount;
- gross edge;
- fees;
- gas;
- slippage;
- MEV reserve;
- funding;
- realized net alpha.

## Accounting invariant

После internal-only операции:

\[
HardNAV_{after}\approx HardNAV_{before}
\]

с поправкой только на реальные transaction costs.

После external alpha:

\[
HardNAV_{after}
=
HardNAV_{before}
+
RealizedExternalAlpha
-
DividendPaid
\]

## Dividend accounting

При выплате:

\[
Treasury_{after}=Treasury_{before}-Dividend
\]

\[
CumulativeDividends_{after}
=
CumulativeDividends_{before}+Dividend
\]

Экономический total generated value:

\[
V_{generated}=ResidualHardNAV+CumulativeDividends
\]

## Анти-double-count

Запрещено одновременно считать один и тот же canonical asset:

- как treasury asset;
- и как LP reserve;
- и как bridge inventory;
- и как paid dividend.

Каждая единица canonical должна иметь одно текущее состояние владения.
