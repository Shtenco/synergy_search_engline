import math

def simulate_multiplier(
    cycles=100,
    initial_deposit=1.0,
    gross_dex_edge=0.03,
    base_utilization=0.90,
    fee_flow=0.001,
    bridge_spread=0.005,
    capacity_x_initial=5.0,
    reinvest=1.0,
    dex_fee=0.003,
    bridge_fee=0.0008,
    gas=0.00015,
    mev=0.00025,
    slippage_k=0.004,
    qe_gain=0.35,
):
    H = initial_deposit
    reserve = 0.0
    u = min(1.0, base_utilization + qe_gain * (1.0 - base_utilization))
    capacity = initial_deposit * capacity_x_initial

    for _ in range(cycles):
        routed = min(H * u, capacity)
        load = routed / max(capacity, 1e-18)

        dex_net = max(
            gross_dex_edge - dex_fee - gas - mev - slippage_k * load * load,
            0.0,
        )
        bridge_net = max(bridge_spread - bridge_fee - gas, 0.0)

        arb = routed * 0.70 * dex_net
        bridge = routed * 0.30 * bridge_net
        external_fees = min(H, capacity) * fee_flow

        realized = arb + bridge + external_fees
        H += realized * reinvest
        reserve += realized * (1.0 - reinvest)

    total = H + reserve
    return {
        "hardnav": total,
        "M_H": total / initial_deposit,
        "residual_working_hardnav": H,
        "reserve": reserve,
    }

if __name__ == "__main__":
    for n in (10, 100, 1000):
        print(n, simulate_multiplier(cycles=n))
