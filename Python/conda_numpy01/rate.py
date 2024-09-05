import numpy as np

# 定义本金、利率和时间
principal = 1000  # 本金，例如1000元
rate = 0.05  # 年利率，例如5%
time = 1  # 时间，例如1年

# 计算简单利息
simple_interest = principal * rate * time

# 计算复利利息，假设每年计息一次
compound_interest_annual = principal * (1 + rate)**time

# 计算复利利息，假设每年计息多次，例如每季度计息
n = 4  # 每年计息次数
compound_interest_quarterly = principal * (1 + rate/n)**(n*time)

# 计算连续复利
continuous_compound_interest = principal * np.exp(rate * time)

print(f"Simple Interest: {simple_interest}")
print(f"Compound Interest (Annual): {compound_interest_annual - principal}")
print(f"Compound Interest (Quarterly): {compound_interest_quarterly - principal}")
print(f"Continuous Compound Interest: {continuous_compound_interest - principal}")
