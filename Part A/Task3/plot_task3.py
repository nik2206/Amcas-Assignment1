import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

vdd = [1.1, 1.05, 1.0, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6]
dv  = [0.729858, 0.673601, 0.615961, 0.557109, 0.497382,
       0.43716, 0.376786, 0.316609, 0.257107, 0.199076, 0.143936]

plt.figure(figsize=(7, 5), facecolor="white")
plt.plot(vdd, dv, marker="o", color="#2563eb", linewidth=2, label="ΔV(BL,BLB)")
plt.axhline(0.025, color="red", linestyle="--", linewidth=1.5,
            label="Sense-amp offset (25 mV)")

plt.xlabel("VDD (V)")
plt.ylabel("ΔV (V)")
plt.title("Part A Task 3: ΔV vs VDD\n6T SRAM read margin, swept 1.1V → 0.6V")
plt.grid(True, linestyle="--", alpha=0.4)
plt.gca().invert_xaxis()   # so it reads left-to-right as VDD decreases
plt.legend()
plt.tight_layout()
plt.savefig("task3_dv_vs_vdd.png", dpi=200, facecolor="white")
print("Saved task3_dv_vs_vdd.png")
