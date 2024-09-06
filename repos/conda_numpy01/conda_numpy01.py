import numpy as np


# 定义被积函数，例如 f(x, y, z)
def f(x: object, y: object, z: object) -> object:
    """
    
    :type x: object
    """
    return x ** 2 * y * np.sin(z)


# 定义积分区间
x_min, x_max = 0, 1
y_min, y_max = 0, 1
z_min, z_max = 0, np.pi

# 生成网格点
x = np.linspace(x_min, x_max, 100)
y = np.linspace(y_min, y_max, 100)
z = np.linspace(z_min, z_max, 100)

# 创建网格数组
X, Y, Z = np.meshgrid(x, y, z, indexing='ij')

# 计算三重积分
# 方法1: 直接使用numpy.traps，注意需要将多维数组转换为一维数组
integral = np.trapz(np.trapz(np.trapz(f(X, Y, Z), z, axis=-1), y, axis=-1), x)

print(f"The triple integral of the function is: {integral}")

