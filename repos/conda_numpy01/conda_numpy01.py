import numpy as np


# ���屻������������ f(x, y, z)
def f(x: object, y: object, z: object) -> object:
    """
    
    :type x: object
    """
    return x ** 2 * y * np.sin(z)


# �����������
x_min, x_max = 0, 1
y_min, y_max = 0, 1
z_min, z_max = 0, np.pi

# ���������
x = np.linspace(x_min, x_max, 100)
y = np.linspace(y_min, y_max, 100)
z = np.linspace(z_min, z_max, 100)

# ������������
X, Y, Z = np.meshgrid(x, y, z, indexing='ij')

# �������ػ���
# ����1: ֱ��ʹ��numpy.traps��ע����Ҫ����ά����ת��Ϊһά����
integral = np.trapz(np.trapz(np.trapz(f(X, Y, Z), z, axis=-1), y, axis=-1), x)

print(f"The triple integral of the function is: {integral}")

