"""Генерация PNG-графиков. Запуск из dashboard/python: python dashboard_generator.py"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import pandas as pd

_BASE = Path(__file__).resolve().parent.parent
CSV_PATH = _BASE / "data" / "game_sessions.csv"
OUT_DIR = _BASE / "screenshots"

plt.rcParams["font.family"] = "DejaVu Sans"


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(CSV_PATH, sep="\t")
    df.columns = [c.strip() for c in df.columns]

    print(df.head())
    print(f"Всего записей: {len(df)}")

    daily_activity = df.groupby("Дата").size().reset_index(name="count")
    daily_activity["Дата"] = pd.to_datetime(daily_activity["Дата"], format="%d.%m.%Y")
    daily_activity = daily_activity.sort_values("Дата")

    plt.figure(figsize=(12, 5))
    plt.bar(
        daily_activity["Дата"].dt.strftime("%d.%m"),
        daily_activity["count"],
        color="steelblue",
    )
    plt.title("Активность: количество прохождений по дням", fontsize=14)
    plt.xlabel("Дата")
    plt.ylabel("Количество прохождений")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig(OUT_DIR / "chart_activity.png", dpi=150, bbox_inches="tight")
    plt.close()
    print("График 1: chart_activity.png")

    endings = df["Концовка"].value_counts()
    plt.figure(figsize=(6, 6))
    colors = ["gold" if str(x).lower() == "good" else "lightcoral" for x in endings.index]
    plt.pie(
        endings.values,
        labels=endings.index,
        autopct="%1.1f%%",
        colors=colors,
        startangle=90,
    )
    plt.title("Распределение концовок (good / bad)", fontsize=14)
    plt.tight_layout()
    plt.savefig(OUT_DIR / "chart_endings.png", dpi=150, bbox_inches="tight")
    plt.close()
    print("График 2: chart_endings.png")

    duration_by_quest = (
        df.groupby("Квест")["Длительность_мин"].mean().sort_values(ascending=False)
    )
    plt.figure(figsize=(10, 6))
    bars = plt.barh(duration_by_quest.index, duration_by_quest.values, color="forestgreen")
    plt.title("Средняя длительность по квестам (минуты)", fontsize=14)
    plt.xlabel("Средняя длительность (мин)")
    for bar, val in zip(bars, duration_by_quest.values):
        plt.text(val + 0.5, bar.get_y() + bar.get_height() / 2, f"{val:.1f}", va="center")
    plt.tight_layout()
    plt.savefig(OUT_DIR / "chart_duration.png", dpi=150, bbox_inches="tight")
    plt.close()
    print("График 3: chart_duration.png")

    success_rate = (df["Концовка"].str.lower() == "good").mean() * 100
    plt.figure(figsize=(4, 3))
    plt.text(
        0.5,
        0.5,
        f"{success_rate:.1f}%",
        fontsize=50,
        ha="center",
        va="center",
        fontweight="bold",
        color="green",
    )
    plt.text(
        0.5,
        0.2,
        "Хороших концовок",
        fontsize=14,
        ha="center",
        va="center",
        color="gray",
    )
    plt.xlim(0, 1)
    plt.ylim(0, 1)
    plt.axis("off")
    plt.tight_layout()
    plt.savefig(OUT_DIR / "chart_success.png", dpi=150, bbox_inches="tight")
    plt.close()
    print(f"График 4: chart_success.png ({success_rate:.1f}% good)")

    print("\n" + "=" * 50)
    print(f"Записей: {len(df)} | Игроков: {df['Игрок'].nunique()} | Квестов: {df['Квест'].nunique()}")
    print(f"Популярный квест: {df['Квест'].mode().iloc[0]}")
    print(f"Дольше всего в среднем: {duration_by_quest.idxmax()} ({duration_by_quest.max():.1f} мин)")
    print(f"PNG в: {OUT_DIR}")


if __name__ == "__main__":
    main()
