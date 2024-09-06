# encoding:utf-8
from scipy.io import loadmat as load
import numpy as np
import matplotlib.pyplot as plt


def reformat(samples, labels):
    #  �ı����ݵ���״
    # ��ͼƬ�ߣ�ͼƬ��ͨ������ͼƬ���� -�� ��ͼƬ����ͼƬ�ߣ�ͼƬ��ͨ������
    # ��   0,    1,    2,      3��  -�� ��   3��   0,    1,      2��
    new = np.transpose(samples, (3, 0, 1, 2)).astype(np.float32)

    # labels ��� one-hot encoding
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


# �����꺯��
# ��ȫ��� def distribution(labels, name):
def distribution(labels, name):
    # ��� labels ����������
    print(f"Labels type: {type(labels)}")

    # ����ά����ת��Ϊһά����
    labels_flat = labels.ravel()

    # ���ת����� labels ���������ͺ���״
    print(f"Labels flat type: {type(labels_flat)}, Labels flat shape: {labels_flat.shape}")

    # ͳ��ÿ����ǩ�ĳ��ִ���
    label_counts = np.bincount(labels_flat)

    # ���Ʒֲ�ͼ
    plt.bar(range(len(label_counts)), label_counts, tick_label=range(len(label_counts)))
    plt.title(f'Distribution of {name} Labels')
    plt.xlabel('Label')
    plt.ylabel('Count')
    plt.show()


# �����꺯����β

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

