import numpy as np
import pandas as pd

INITIAL = 1.0
CAPACITY = 5.0
EDGE = 0.03
BASE_UTIL = 0.90
FEE_FLOW = 0.001
BRIDGE_SPREAD = 0.005
DEX_FEE = 0.003
BRIDGE_FEE = 0.0008
GAS = 0.00015
MEV = 0.00025
SLIPPAGE_K = 0.004
QE_GAIN = 0.35

def effective_utilization():
    return min(1.0, BASE_UTIL + QE_GAIN * (1.0 - BASE_UTIL))

def profit_one_cycle(H):
    u = effective_utilization()
    routed = min(H * u, CAPACITY)
    load = routed / CAPACITY

    dex_net = max(
        EDGE - DEX_FEE - GAS - MEV - SLIPPAGE_K * load * load,
        0.0,
    )
    bridge_net = max(BRIDGE_SPREAD - BRIDGE_FEE - GAS, 0.0)

    arb = routed * 0.70 * dex_net
    bridge = routed * 0.30 * bridge_net
    fees = min(H, CAPACITY) * FEE_FLOW

    return arb + bridge + fees

def run_policy(cycles, target_H, build_reinvest, payout_after_target):
    H = INITIAL
    dividends = 0.0
    div_series = []

    for _ in range(cycles):
        profit = profit_one_cycle(H)

        if H < target_H:
            max_needed = max(target_H - H, 0.0)
            reinvest = min(profit * build_reinvest, max_needed)
            dividend = profit - reinvest
        else:
            dividend = profit * payout_after_target
            reinvest = profit - dividend

        H += reinvest
        dividends += dividend
        div_series.append(dividend)

    tail = div_series[-min(100, len(div_series)):]

    return {
        "cycles": cycles,
        "target_H": target_H,
        "build_reinvest": build_reinvest,
        "payout_after_target": payout_after_target,
        "final_H": H,
        "M_D": dividends / INITIAL,
        "tail_dividend_rate_per_cycle": sum(tail) / len(tail) / INITIAL,
        "total_generated_value": H + dividends,
    }

def grid():
    rows = []
    for cycles in (100, 1000):
        for target in np.arange(1.0, 10.01, 0.25):
            for build in (0.5, 0.75, 0.9, 1.0):
                for payout in (0.25, 0.5, 0.75, 0.9, 1.0):
                    rows.append(run_policy(
                        cycles,
                        float(round(target, 2)),
                        build,
                        payout,
                    ))
    return pd.DataFrame(rows)

if __name__ == "__main__":
    df = grid()
    for cycles in (100, 1000):
        sub = df[df.cycles == cycles]
        print("\nHORIZON", cycles)
        print(sub.sort_values("M_D", ascending=False).head(10).to_string(index=False))
