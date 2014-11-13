package com.cosc304;

public class Items {
	private String name = "";
	private int quant = 0;
	private int size = 0;
	private int pid = 0;
	private double price = 0;
	private int stock = 0;
	private String ptype="";
	private String pgender="";
	private String pdescription="";
	private int tid = 0;
	private double discount = 0;
	private double itemPrice = 0;
	private double cost = 0; // this is quant * price - discount;
	
	public Items(){}
	
	public Items(int quantity, double discount, int size){
		this.quant = quantity;
		this.discount = discount;
		this.size = size;
	}
	
	public Items(String pname, Integer pid, double price, int stock, String ptype, String pgender, String pdescription, int size, int thumbId, double discount) {
		setPname(pname);
		setPid(pid);
		setPrice(price);
		setStock(stock);
		setPtype(ptype);
		setPgender(pgender);
		setPdescription(pdescription);
		setSize(size);
		setThumbId(thumbId);
		setDiscount(0);
		//!@# left out picID and photoID for now.
		
		
		//!@#do a check for pid=THE DEAL (currrently)
		//discount=0 for itemPage
	}
	public double getDiscount(){
		return discount;
	}
	
	public void setPname(String name){
		this.name = name;
	}
	public void setItemPrice(double price){
		this.itemPrice = price;
		setCost();
	}
	private void setCost(){
		cost = (itemPrice * quant) * (1 - discount);
	}
	public double getCost(){
		return cost;
	}	
	public int getQuantity(){
		return quant;
	}
	public int getSize(){
		return size;
	}
	public void setThumbId(int id){
		this.tid = id;
	}
	public int getThumbId(){
		return tid;
	}
	public String getPname() {
		return name;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public String getPtype() {
		return ptype;
	}
	public void setPtype(String ptype) {
		this.ptype = ptype;
	}
	public String getPgender() {
		return pgender;
	}
	public void setPgender(String pgender) {
		this.pgender = pgender;
	}
	public String getPdescription(){
		return pdescription;
	}
	public void setPdescription(String desc){
		pdescription=desc;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public void setDiscount(double discount){
		this.discount = discount;
	}
	public void setQuantity(int q){
		this.quant = q;
	}
}
