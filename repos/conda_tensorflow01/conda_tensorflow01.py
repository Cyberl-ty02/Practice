# encoding:utf-8
from scipy.io import loadmat as load
import numpy as np
import matplotlib.pyplot as plt


def reformat(samples, labels):
    #  改变数据的形状
    # （图片高，图片宽，通道数，图片数） -》 （图片数，图片高，图片宽，通道数）
    # （   0,    1,    2,      3）  -》 （   3，   0,    1,      2）
    new = np.transpose(samples, (3, 0, 1, 2)).astype(np.float32)

    # labels 变成 one-hot encoding
    labels = np.array([x[0] for x in labels])
    one_hot_labels = []

    for num in labels:
        one_hot = [0.0] * 10
        if num == 10:
            one_hot[0] = 1.0
        else:
            one_hot[num] = 1.0
        one_hot_labels.append(one_hot)
    labels = np.array(one_hot_labels)
    return new, labels


def normalize(samples):
    # (R+G+B)/3
    # 0~255 -> -1.0~1.0
    a = np.add.reduce(samples, keepdims=True, axis=3)
    a = a / 3.0
    return a / 128.0 - 1.0


# 待补完函数
# 补全后的 def distribution(labels, name):
def distribution(labels, name):
    # 检查 labels 的数据类型
    print(f"Labels type: {type(labels)}")

    # 将多维数组转换为一维数组
    labels_flat = labels.ravel()

    # 检查转换后的 labels 的数据类型和形状
    print(f"Labels flat type: {type(labels_flat)}, Labels flat shape: {labels_flat.shape}")

    # 统计每个标签的出现次数
    label_counts = np.bincount(labels_flat)

    # 绘制分布图
    plt.bar(range(len(label_counts)), label_counts, tick_label=range(len(label_counts)))
    plt.title(f'Distribution of {name} Labels')
    plt.xlabel('Label')
    plt.ylabel('Count')
    plt.show()


# 待补完函数结尾

def inspect(dataset, labels, i):
    print(labels[i])
    plt.imshow(dataset[i].squeeze())
    plt.show()


train: dict = load('data/test_32x32.mat')
train = load('data/test_32x32.mat')

train_samples = train['X']
train_labels = train['y']

print(type(train_samples))
print(type(train_labels))

train_samples = train['X']
train_labels = train['y']

n_train_samples, _train_labels = reformat(train_samples, train_labels)
print(n_train_samples.shape)
print(_train_labels.shape)
n_train_samples, _train_labels = reformat(train_samples, train_labels)

_train_samples = normalize(n_train_samples)
_train_samples = normalize(n_train_samples)

num_labels = 10
image_size = 32
num_channels = 1

if __name__ == '__main__':
    _train_samples = normalize(_train_samples)
    print(_train_samples.shape)
    inspect(_train_samples, _train_labels, 19999)
    distribution(train_labels, 'Train Labels')

