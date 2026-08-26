import matplotlib
matplotlib.use("Agg")
import csv
import matplotlib.pyplot as plt

x = []
y = []
labels = []

with open("task2_sweep_results.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        x.append(int(row["log2_capacity_kb"]))
        y.append(float(row["access_time_ns"]))
        labels.append(row["capacity_label"])

plt.figure(figsize=(7, 5))
plt.plot(x, y, marker="o", linewidth=2, color="#2563eb")

for xi, yi, lbl in zip(x, y, labels):
    plt.annotate(lbl, (xi, yi), textcoords="offset points", xytext=(0, 8), ha="center", fontsize=9)

plt.xlabel("log2(Capacity relative to 256KB)")
plt.ylabel("Access time (ns)")
plt.title("Part B Task 2: Access Time vs log2(Capacity)\n2MB SRAM L2 config, 45nm, banks fixed at 4")
plt.grid(True, linestyle="--", alpha=0.5)
plt.tight_layout()
plt.savefig("task2_access_time_plot.png", dpi=200)
print("Saved plot to task2_access_time_plot.png")
