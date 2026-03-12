// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MarketPlaceProduct {
  String? id;
  String? product_name;
  String? category_name;
  String? brand_name;
  String? unit;
  String? weight;
  String? description;
  String? image_path;
  String? price;
  String? discount_type;
  String? discount;
  String? tax;
  String? vat;
  ProductStore? product_store;
  String? status;
  String? product_condition;
  String? shipping_method;
  String? is_physical_product;
  String? shipping_weight;
  String? shipping_height;
  String? length;
  String? width;
  String? user_id;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  MarketPlaceProduct({
    this.id,
    this.product_name,
    this.category_name,
    this.brand_name,
    this.unit,
    this.weight,
    this.description,
    this.image_path,
    this.price,
    this.discount_type,
    this.discount,
    this.tax,
    this.vat,
    this.product_store,
    this.status,
    this.product_condition,
    this.shipping_method,
    this.is_physical_product,
    this.shipping_weight,
    this.shipping_height,
    this.length,
    this.width,
    this.user_id,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MarketPlaceProduct copyWith({
    String? id,
    String? product_name,
    String? category_name,
    String? brand_name,
    String? unit,
    String? weight,
    String? description,
    String? image_path,
    String? price,
    String? discount_type,
    String? discount,
    String? tax,
    String? vat,
    ProductStore? product_store,
    String? status,
    String? product_condition,
    String? shipping_method,
    String? is_physical_product,
    String? shipping_weight,
    String? shipping_height,
    String? length,
    String? width,
    String? user_id,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return MarketPlaceProduct(
      id: id ?? this.id,
      product_name: product_name ?? this.product_name,
      category_name: category_name ?? this.category_name,
      brand_name: brand_name ?? this.brand_name,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      image_path: image_path ?? this.image_path,
      price: price ?? this.price,
      discount_type: discount_type ?? this.discount_type,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      vat: vat ?? this.vat,
      product_store: product_store ?? this.product_store,
      status: status ?? this.status,
      product_condition: product_condition ?? this.product_condition,
      shipping_method: shipping_method ?? this.shipping_method,
      is_physical_product: is_physical_product ?? this.is_physical_product,
      shipping_weight: shipping_weight ?? this.shipping_weight,
      shipping_height: shipping_height ?? this.shipping_height,
      length: length ?? this.length,
      width: width ?? this.width,
      user_id: user_id ?? this.user_id,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'product_name': product_name,
      'category_name': category_name,
      'brand_name': brand_name,
      'unit': unit,
      'weight': weight,
      'description': description,
      'image_path': image_path,
      'price': price,
      'discount_type': discount_type,
      'discount': discount,
      'tax': tax,
      'vat': vat,
      'product_store': product_store?.toMap(),
      'status': status,
      'product_condition': product_condition,
      'shipping_method': shipping_method,
      'is_physical_product': is_physical_product,
      'shipping_weight': shipping_weight,
      'shipping_height': shipping_height,
      'length': length,
      'width': width,
      'user_id': user_id,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory MarketPlaceProduct.fromMap(Map<String, dynamic> map) {
    return MarketPlaceProduct(
      id: map['_id'] != null ? map['_id'] as String : null,
      product_name:
          map['product_name'] != null ? map['product_name'] as String : null,
      category_name:
          map['category_name'] != null ? map['category_name'] as String : null,
      brand_name:
          map['brand_name'] != null ? map['brand_name'] as String : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      image_path:
          map['image_path'] != null ? map['image_path'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      discount_type:
          map['discount_type'] != null ? map['discount_type'] as String : null,
      discount: map['discount'] != null ? map['discount'] as String : null,
      tax: map['tax'] != null ? map['tax'] as String : null,
      vat: map['vat'] != null ? map['vat'] as String : null,
      product_store: map['product_store'] != null
          ? ProductStore.fromMap(map['product_store'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      product_condition: map['product_condition'] != null
          ? map['product_condition'] as String
          : null,
      shipping_method: map['shipping_method'] != null
          ? map['shipping_method'] as String
          : null,
      is_physical_product: map['is_physical_product'] != null
          ? map['is_physical_product'] as String
          : null,
      shipping_weight: map['shipping_weight'] != null
          ? map['shipping_weight'] as String
          : null,
      shipping_height: map['shipping_height'] != null
          ? map['shipping_height'] as String
          : null,
      length: map['length'] != null ? map['length'] as String : null,
      width: map['width'] != null ? map['width'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketPlaceProduct.fromJson(String source) =>
      MarketPlaceProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MarketPlaceProduct(id: $id, product_name: $product_name, category_name: $category_name, brand_name: $brand_name, unit: $unit, weight: $weight, description: $description, image_path: $image_path, price: $price, discount_type: $discount_type, discount: $discount, tax: $tax, vat: $vat, product_store: $product_store, status: $status, product_condition: $product_condition, shipping_method: $shipping_method, is_physical_product: $is_physical_product, shipping_weight: $shipping_weight, shipping_height: $shipping_height, length: $length, width: $width, user_id: $user_id, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant MarketPlaceProduct other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.product_name == product_name &&
        other.category_name == category_name &&
        other.brand_name == brand_name &&
        other.unit == unit &&
        other.weight == weight &&
        other.description == description &&
        other.image_path == image_path &&
        other.price == price &&
        other.discount_type == discount_type &&
        other.discount == discount &&
        other.tax == tax &&
        other.vat == vat &&
        other.product_store == product_store &&
        other.status == status &&
        other.product_condition == product_condition &&
        other.shipping_method == shipping_method &&
        other.is_physical_product == is_physical_product &&
        other.shipping_weight == shipping_weight &&
        other.shipping_height == shipping_height &&
        other.length == length &&
        other.width == width &&
        other.user_id == user_id &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product_name.hashCode ^
        category_name.hashCode ^
        brand_name.hashCode ^
        unit.hashCode ^
        weight.hashCode ^
        description.hashCode ^
        image_path.hashCode ^
        price.hashCode ^
        discount_type.hashCode ^
        discount.hashCode ^
        tax.hashCode ^
        vat.hashCode ^
        product_store.hashCode ^
        status.hashCode ^
        product_condition.hashCode ^
        shipping_method.hashCode ^
        is_physical_product.hashCode ^
        shipping_weight.hashCode ^
        shipping_height.hashCode ^
        length.hashCode ^
        width.hashCode ^
        user_id.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class ProductStore {
  String? id;
  String? category_name;
  String? user_id;
  String? page_id;
  String? name;
  String? description;
  String? image_path;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  ProductStore({
    this.id,
    this.category_name,
    this.user_id,
    this.page_id,
    this.name,
    this.description,
    this.image_path,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ProductStore copyWith({
    String? id,
    String? category_name,
    String? user_id,
    String? page_id,
    String? name,
    String? description,
    String? image_path,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return ProductStore(
      id: id ?? this.id,
      category_name: category_name ?? this.category_name,
      user_id: user_id ?? this.user_id,
      page_id: page_id ?? this.page_id,
      name: name ?? this.name,
      description: description ?? this.description,
      image_path: image_path ?? this.image_path,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'category_name': category_name,
      'user_id': user_id,
      'page_id': page_id,
      'name': name,
      'description': description,
      'image_path': image_path,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory ProductStore.fromMap(Map<String, dynamic> map) {
    return ProductStore(
      id: map['_id'] != null ? map['_id'] as String : null,
      category_name:
          map['category_name'] != null ? map['category_name'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      image_path:
          map['image_path'] != null ? map['image_path'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductStore.fromJson(String source) =>
      ProductStore.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductStore(id: $id, category_name: $category_name, user_id: $user_id, page_id: $page_id, name: $name, description: $description, image_path: $image_path, status: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant ProductStore other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.category_name == category_name &&
        other.user_id == user_id &&
        other.page_id == page_id &&
        other.name == name &&
        other.description == description &&
        other.image_path == image_path &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category_name.hashCode ^
        user_id.hashCode ^
        page_id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image_path.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
