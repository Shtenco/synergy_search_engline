from hardnav_multiplier_v2 import simulate_multiplier

def one_cycle_profit(
    H,
    initial=1.0,
    edge=0.03,
    base_util=0.90,
    fee_flow=0.001,
    bridge_spread=0.005,
    capacity_x=5.0,
    dex_fee=0.003,
    bridge_fee=0.0008,
    gas=0.00015,
    mev=0.00025,
    slippage_k=0.004,
    qe_gain=0.35,
):
    u = min(1.0, base_util + qe_gain * (1.0 - base_util))
    capacity = initial * capacity_x
    routed = min(H * u, capacity)
    load = routed / max(capacity, 1e-18)
    dex_net = max(edge - dex_fee - gas - mev - slippage_k * load * load, 0.0)
    bridge_net = max(bridge_spread - bridge_fee - gas, 0.0)

    return (
        routed * 0.70 * dex_net
        + routed * 0.30 * bridge_net
        + min(H, capacity) * fee_flow
    )

def threshold_policy(cycles=1000, target_hardnav=5.35):
    H = 1.0
    dividends = 0.0

    for _ in range(cycles):
        profit = one_cycle_profit(H)
        need = max(target_hardnav - H, 0.0)
        reinvest = min(profit, need)
        dividend = profit - reinvest

        H += reinvest
        dividends += dividend

    return {
        "remaining_hardnav": H,
        "canonical_dividends": dividends,
        "M_D": dividends,
        "total_generated_value": H + dividends,
    }

if __name__ == "__main__":
    for n in (10, 100, 1000):
        print(n, threshold_policy(cycles=n))
