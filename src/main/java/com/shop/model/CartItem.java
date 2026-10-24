package com.shop.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private int productId;
    private String name;
    private String imageUrl;
    private BigDecimal price;
    private int stock;
    private int quantity;

    public CartItem(Product p, int quantity) {
        this.productId = p.getId();
        this.name = p.getName();
        this.imageUrl = p.getImageUrl();
        this.price = p.getPrice();
        this.stock = p.getStock();
        this.quantity = quantity;
    }

    public int getProductId() { return productId; }
    public String getName() { return name; }
    public String getImageUrl() { return imageUrl; }
    public BigDecimal getPrice() { return price; }
    public int getStock() { return stock; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getSubtotal() { return price.multiply(BigDecimal.valueOf(quantity)); }
}
