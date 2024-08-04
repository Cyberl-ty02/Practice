# 导入所需的模块
import sys
import sqlite3
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QLabel, QLineEdit, QPushButton, QTableWidget, QTableWidgetItem, QVBoxLayout, QHBoxLayout, QMessageBox


class SupermarketManagementSystem(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('超市管理系统')
        self.setGeometry(100, 100, 800, 600)

        self.db_connection = sqlite3.connect('supermarket.db')
        self.create_tables()

        self.init_ui()

    def create_tables(self):
        cursor = self.db_connection.cursor()

        # 商品表
        cursor.execute('''CREATE TABLE IF NOT EXISTS products (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT,
                            price REAL,
                            category_id INTEGER,
                            brand_id INTEGER)''')

        # 顾客表
        cursor.execute('''CREATE TABLE IF NOT EXISTS customers (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT,
                            email TEXT,
                            phone TEXT)''')

        # 订单表
        cursor.execute('''CREATE TABLE IF NOT EXISTS orders (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            customer_id INTEGER,
                            date TEXT,
                            FOREIGN KEY (customer_id) REFERENCES customers(id))''')

        # 订单商品表
        cursor.execute('''CREATE TABLE IF NOT EXISTS order_products (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            order_id INTEGER,
                            product_id INTEGER,
                            quantity INTEGER,
                            FOREIGN KEY (order_id) REFERENCES orders(id),
                            FOREIGN KEY (product_id) REFERENCES products(id))''')

        # 商品分类表
        cursor.execute('''CREATE TABLE IF NOT EXISTS categories (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT)''')

        # 商品分类关联表
        cursor.execute('''CREATE TABLE IF NOT EXISTS product_categories (
                            product_id INTEGER,
                            category_id INTEGER,
                            FOREIGN KEY (product_id) REFERENCES products(id),
                            FOREIGN KEY (category_id) REFERENCES categories(id))''')

        # 商品品牌表
        cursor.execute('''CREATE TABLE IF NOT EXISTS brands (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT)''')

        # 商品品牌关联表
        cursor.execute('''CREATE TABLE IF NOT EXISTS product_brands (
                            product_id INTEGER,
                            brand_id INTEGER,
                            FOREIGN KEY (product_id) REFERENCES products(id),
                            FOREIGN KEY (brand_id) REFERENCES brands(id))''')

        self.db_connection.commit()

    def init_ui(self):
        # 商品管理界面
        product_label = QLabel('商品管理')
        product_name_label = QLabel('名称：')
        self.product_name_input = QLineEdit()
        product_price_label = QLabel('价格：')
        self.product_price_input = QLineEdit()
        product_category_label = QLabel('分类：')
        self.product_category_input = QLineEdit()
        product_brand_label = QLabel('品牌：')
        self.product_brand_input = QLineEdit()
        add_product_button = QPushButton('添加商品')
        add_product_button.clicked.connect(self.add_product)
        update_product_button = QPushButton('更新商品')
        update_product_button.clicked.connect(self.update_product)
        delete_product_button = QPushButton('删除商品')
        delete_product_button.clicked.connect(self.delete_product)
        search_product_button = QPushButton('查询商品')
        search_product_button.clicked.connect(self.search_product)

        self.product_table = QTableWidget()
        self.product_table.setColumnCount(5)
        self.product_table.setHorizontalHeaderLabels(['ID', '名称', '价格', '分类', '品牌'])

        product_layout = QVBoxLayout()
        product_layout.addWidget(product_label)
        product_layout.addWidget(product_name_label)
        product_layout.addWidget(self.product_name_input)
        product_layout.addWidget(product_price_label)
        product_layout.addWidget(self.product_price_input)
        product_layout.addWidget(product_category_label)
        product_layout.addWidget(self.product_category_input)
        product_layout.addWidget(product_brand_label)
        product_layout.addWidget(self.product_brand_input)
        product_layout.addWidget(add_product_button)
        product_layout.addWidget(update_product_button)
        product_layout.addWidget(delete_product_button)
        product_layout.addWidget(search_product_button)
        product_layout.addWidget(self.product_table)

        # 顾客管理界面
        customer_label = QLabel('顾客管理')
        customer_name_label = QLabel('姓名：')
        self.customer_name_input = QLineEdit()
        customer_email_label = QLabel('邮箱：')
        self.customer_email_input = QLineEdit()
        customer_phone_label = QLabel('电话：')
        self.customer_phone_input = QLineEdit()
        add_customer_button = QPushButton('新顾客')
        add_customer_button.clicked.connect(self.add_customer)
        update_customer_button = QPushButton('更新顾客信息')
        update_customer_button.clicked.connect(self.update_customer)
        delete_customer_button = QPushButton('清除顾客信息')
        delete_customer_button.clicked.connect(self.delete_customer)
        search_customer_button = QPushButton('查询顾客')
        search_customer_button.clicked.connect(self.search_customer)

        self.customer_table = QTableWidget()
        self.customer_table.setColumnCount(4)
        self.customer_table.setHorizontalHeaderLabels(['ID', '姓名', '邮箱', '电话'])

        customer_layout = QVBoxLayout()
        customer_layout.addWidget(customer_label)
        customer_layout.addWidget(customer_name_label)
        customer_layout.addWidget(self.customer_name_input)
        customer_layout.addWidget(customer_email_label)
        customer_layout.addWidget(self.customer_email_input)
        customer_layout.addWidget(customer_phone_label)
        customer_layout.addWidget(self.customer_phone_input)
        customer_layout.addWidget(add_customer_button)
        customer_layout.addWidget(update_customer_button)
        customer_layout.addWidget(delete_customer_button)
        customer_layout.addWidget(search_customer_button)
        customer_layout.addWidget(self.customer_table)

        # 主布局
        main_layout = QHBoxLayout()
        main_layout.addLayout(product_layout)
        main_layout.addLayout(customer_layout)

        central_widget = QWidget()
        central_widget.setLayout(main_layout)
        self.setCentralWidget(central_widget)

    def add_product(self):
        name = self.product_name_input.text()
        price = self.product_price_input.text()
        category = self.product_category_input.text()
        brand = self.product_brand_input.text()

        if name and price and category and brand:
            cursor = self.db_connection.cursor()

            # 添加商品
            cursor.execute('''INSERT INTO products (name, price) VALUES (?, ?)''', (name, price))
            product_id = cursor.lastrowid

            # 添加商品分类
            cursor.execute('''INSERT INTO categories (name) VALUES (?)''', (category,))
            category_id = cursor.lastrowid

            # 添加商品品牌
            cursor.execute('''INSERT INTO brands (name) VALUES (?)''', (brand,))
            brand_id = cursor.lastrowid

            # 关联商品分类
            cursor.execute('''INSERT INTO product_categories (product_id, category_id) VALUES (?, ?)''',
                           (product_id, category_id))

            # 关联商品品牌
            cursor.execute('''INSERT INTO product_brands (product_id, brand_id) VALUES (?, ?)''',
                           (product_id, brand_id))

            self.db_connection.commit()
            self.show_message('成功', '商品添加成功。')
        else:
            self.show_message('错误', '请输入所有字段。')

    def update_product(self):
        selected_row = self.product_table.currentRow()

        if selected_row >= 0:
            product_id = int(self.product_table.item(selected_row, 0).text())
            name = self.product_name_input.text()
            price = self.product_price_input.text()
            category = self.product_category_input.text()
            brand = self.product_brand_input.text()

            if name and price and category and brand:
                cursor = self.db_connection.cursor()

                # 更新商品
                cursor.execute('''UPDATE products SET name=?, price=? WHERE id=?''', (name, price, product_id))

                # 更新商品分类
                cursor.execute('''SELECT category_id FROM product_categories WHERE product_id=?''', (product_id,))
                category_id = cursor.fetchone()[0]
                cursor.execute('''UPDATE categories SET name=? WHERE id=?''', (category, category_id))

                # 更新商品品牌
                cursor.execute('''SELECT brand_id FROM product_brands WHERE product_id=?''', (product_id,))
                brand_id = cursor.fetchone()[0]
                cursor.execute('''UPDATE brands SET name=? WHERE id=?''', (brand, brand_id))

                self.db_connection.commit()
                self.show_message('成功', '商品更新成功。')
            else:
                self.show_message('错误', '请输入所有字段。')
        else:
            self.show_message('错误', '请选择要更新的商品。')

    def delete_product(self):
        selected_row = self.product_table.currentRow()

        if selected_row >= 0:
            product_id = int(self.product_table.item(selected_row, 0).text())

            cursor = self.db_connection.cursor()

            # 删除商品
            cursor.execute('''DELETE FROM products WHERE id=?''', (product_id,))

            self.db_connection.commit()
            self.show_message('成功', '商品删除成功。')
        else:
            self.show_message('错误', '请选择要删除的商品。')

    def search_product(self):
        name = self.product_name_input.text()
        category = self.product_category_input.text()
        brand = self.product_brand_input.text()

        cursor = self.db_connection.cursor()

        if name and category and brand:
            # 查询商品
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE products.name LIKE ? AND categories.name LIKE ? AND brands.name LIKE ?''',
                           (f'%{name}%', f'%{category}%', f'%{brand}%'))
        elif name and category:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE products.name LIKE ? AND categories.name LIKE ?''',
                           (f'%{name}%', f'%{category}%'))
        elif name and brand:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE products.name LIKE ? AND brands.name LIKE ?''',
                           (f'%{name}%', f'%{brand}%'))
        elif category and brand:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE categories.name LIKE ? AND brands.name LIKE ?''',
                           (f'%{category}%', f'%{brand}%'))
        elif name:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE products.name LIKE ?''',
                           (f'%{name}%',))
        elif category:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE categories.name LIKE ?''',
                           (f'%{category}%',))
        elif brand:
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id
                              WHERE brands.name LIKE ?''',
                           (f'%{brand}%',))
        else:
            # 查询所有商品
            cursor.execute('''SELECT products.id, products.name, products.price, categories.name, brands.name
                              FROM products
                              INNER JOIN product_categories ON products.id = product_categories.product_id
                              INNER JOIN categories ON product_categories.category_id = categories.id
                              INNER JOIN product_brands ON products.id = product_brands.product_id
                              INNER JOIN brands ON product_brands.brand_id = brands.id''')

        result = cursor.fetchall()

        self.product_table.setRowCount(0)

        if result:
            self.product_table.setRowCount(len(result))
            for row, row_data in enumerate(result):
                for column, value in enumerate(row_data):
                    item = QTableWidgetItem(str(value))
                    self.product_table.setItem(row, column, item)
        else:
            self.show_message('提示', '没有找到匹配的商品。')

    def add_customer(self):
        name = self.customer_name_input.text()
        email = self.customer_email_input.text()
        phone = self.customer_phone_input.text()

        if name and email and phone:
            cursor = self.db_connection.cursor()

            # 新顾客
            cursor.execute('''INSERT INTO customers (name, email, phone) VALUES (?, ?, ?)''', (name, email, phone))
            customer_id = cursor.lastrowid

            self.db_connection.commit()
            self.show_message('成功', '顾客添加成功。')
        else:
            self.show_message('错误', '请输入所有字段。')

    def update_customer(self):
        selected_row = self.customer_table.currentRow()

        if selected_row >= 0:
            customer_id = int(self.customer_table.item(selected_row, 0).text())
            name = self.customer_name_input.text()
            email = self.customer_email_input.text()
            phone = self.customer_phone_input.text()

            if name and email and phone:
                cursor = self.db_connection.cursor()

                # 更新顾客信息
                cursor.execute('''UPDATE customers SET name=?, email=?, phone=? WHERE id=?''',
                               (name, email, phone, customer_id))

                self.db_connection.commit()
                self.show_message('成功', '顾客更新成功。')
            else:
                self.show_message('错误', '请输入所有字段。')
        else:
            self.show_message('错误', '请选择要更新的顾客。')

    def delete_customer(self):
        selected_row = self.customer_table.currentRow()

        if selected_row >= 0:
            customer_id = int(self.customer_table.item(selected_row, 0).text())

            cursor = self.db_connection.cursor()

            # 清除顾客信息
            cursor.execute('''DELETE FROM customers WHERE id=?''', (customer_id,))

            self.db_connection.commit()
            self.show_message('成功', '顾客删除成功。')
        else:
            self.show_message('错误', '请选择要删除的顾客。')

    def search_customer(self):
        name = self.customer_name_input.text()
        email = self.customer_email_input.text()
        phone = self.customer_phone_input.text()

        cursor = self.db_connection.cursor()

        if name and email and phone:
            # 查询顾客
            cursor.execute('''SELECT * FROM customers WHERE name LIKE ? AND email LIKE ? AND phone LIKE ?''',
                           (f'%{name}%', f'%{email}%', f'%{phone}%'))
        elif name and email:
            cursor.execute('''SELECT * FROM customers WHERE name LIKE ? AND email LIKE ?''',
                           (f'%{name}%', f'%{email}%'))
        elif name and phone:
            cursor.execute('''SELECT * FROM customers WHERE name LIKE ? AND phone LIKE ?''',
                           (f'%{name}%', f'%{phone}%'))
        elif email and phone:
            cursor.execute('''SELECT * FROM customers WHERE email LIKE ? AND phone LIKE ?''',
                           (f'%{email}%', f'%{phone}%'))
        elif name:
            cursor.execute('''SELECT * FROM customers WHERE name LIKE ?''', (f'%{name}%',))
        elif email:
            cursor.execute('''SELECT * FROM customers WHERE email LIKE ?''', (f'%{email}%',))
        elif phone:
            cursor.execute('''SELECT * FROM customers WHERE phone LIKE ?''', (f'%{phone}%',))
        else:
            # 查询所有顾客
            cursor.execute('''SELECT * FROM customers''')

        result = cursor.fetchall()

        self.customer_table.setRowCount(0)

        if result:
            self.customer_table.setRowCount(len(result))
            for row, row_data in enumerate(result):
                for column, value in enumerate(row_data):
                    item = QTableWidgetItem(str(value))
                    self.customer_table.setItem(row, column, item)
        else:
            self.show_message('提示', '没有找到匹配的顾客。')

    def show_message(self, title, message):
        msg_box = QMessageBox()
        msg_box.setWindowTitle(title)
        msg_box.setText(message)
        msg_box.exec_()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = SupermarketManagementSystem()
    window.show()
    sys.exit(app.exec_())
