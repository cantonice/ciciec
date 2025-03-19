//****************************************Copyright (c)***********************************//
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取FPGA & STM32资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved                               
//----------------------------------------------------------------------------------------
// File name:           ov7725_rgb565_640x480_lcd
// Last modified Date:  2018/3/21 13:58:23
// Last Version:        V1.0
// Descriptions:        OV7725摄像头RGB TFT-LCD显示实验
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2018/3/21 13:58:23
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ov7725_lcd(    
    input                 sys_clk     ,  //系统时钟
    input                 sys_rst_n   ,  //系统复位，低电平有效
    //摄像头接口
    input                 cam_pclk    ,  //cmos 数据像素时钟
    input                 cam_vsync   ,  //cmos 场同步信号
    input                 cam_href    ,  //cmos 行同步信号
    input        [7:0]    cam_data    ,  //cmos 数据
    output                cam_rst_n   ,  //cmos 复位信号，低电平有效
    output                cam_sgm_ctrl,  //cmos 时钟选择信号, 1:使用摄像头自带的晶振
    output                cam_scl     ,  //cmos SCCB_SCL线
    inout                 cam_sda     ,  //cmos SCCB_SDA线
    //SDRAM接口
    output                sdram_clk   ,  //SDRAM 时钟
    output                sdram_cke   ,  //SDRAM 时钟有效
    output                sdram_cs_n  ,  //SDRAM 片选
    output                sdram_ras_n ,  //SDRAM 行有效
    output                sdram_cas_n ,  //SDRAM 列有效
    output                sdram_we_n  ,  //SDRAM 写有效
    output       [1:0]    sdram_ba    ,  //SDRAM Bank地址
    output       [1:0]    sdram_dqm   ,  //SDRAM 数据掩码
    output       [12:0]   sdram_addr  ,  //SDRAM 地址
    inout        [15:0]   sdram_data  ,  //SDRAM 数据    
    //lcd接口
    output                lcd_hs      ,  //LCD 行同步信号
    output                lcd_vs      ,  //LCD 场同步信号
    output                lcd_de      ,  //LCD 数据输入使能
    inout        [15:0]   lcd_rgb     ,  //LCD RGB565颜色数据
    output                lcd_bl      ,  //LCD 背光控制信号
    output                lcd_rst     ,  //LCD 复位信号
    output                lcd_pclk       //LCD 采样时钟
    );

//parameter define
parameter  SLAVE_ADDR = 7'h21         ;  //OV7725的器件地址7'h21
parameter  BIT_CTRL   = 1'b0          ;  //OV7725的字节地址为8位  0:8位 1:16位
parameter  CLK_FREQ   = 26'd50_000_000;  //i2c_dri模块的驱动时钟频率 50MHz
parameter  I2C_FREQ   = 18'd250_000   ;  //I2C的SCL时钟频率,不超过400KHz

//wire define
wire                  clk_100m            ;  //100mhz时钟,SDRAM操作时钟
wire                  clk_100m_shift      ;  //100mhz时钟,SDRAM相位偏移时钟
wire                  clk_50m             ;  //50mhz时钟,提供给lcd驱动时钟
wire                  locked              ;
wire                  rst_n               ;                                      
       
wire                  cam_init_done       ;  //摄像头初始化完成

wire                  wr_en               ;  //sdram_ctrl模块写使能
wire   [15:0]         wr_data             ;  //sdram_ctrl模块写数据
wire                  rd_en               ;  //sdram_ctrl模块读使能
wire                  sdram_init_done     ;  //SDRAM初始化完成
wire                  rdata_req           ;  //SDRAM控制器模块读使能
wire   [15:0]         rd_data             ;  //SDRAM控制器模块读数据
wire                  cmos_frame_valid    ;  //数据有效使能信号
wire                  init_calib_complete ;  //SDRAM初始化完成init_calib_complete
wire                  sys_init_done       ;  //系统初始化完成(SDRAM初始化+摄像头初始化)

wire                  lcd_clk             ;  //分频产生的LCD 采样时钟
wire    [10:0]        h_disp              ;  //LCD屏水平分辨率
wire    [10:0]        v_disp              ;  //LCD屏垂直分辨率     
wire    [10:0]        h_pixel             ;  //存入SDRAM的水平分辨率        
wire    [10:0]        v_pixel             ;  //存入SDRAM的屏垂直分辨率 
wire    [15:0]        lcd_id              ;  //LCD屏的ID号
wire    [27:0]        sdram_addr_max      ;  //存入SDRAM的最大读写地址

//*****************************************************
//**                    main code
//*****************************************************

assign  rst_n = sys_rst_n & locked;
//系统初始化完成：SDRAM和摄像头都初始化完成
//避免了在SDRAM初始化过程中向里面写入数据
assign  sys_init_done = sdram_init_done & cam_init_done;
//不对摄像头硬件复位,固定高电平
assign  cam_rst_n = 1'b1;
//cmos 时钟选择信号, 1:使用摄像头自带的晶振
assign  cam_sgm_ctrl = 1'b1;

//锁相环
pll_clk u_pll_clk(
    .areset             (~sys_rst_n),
    .inclk0             (sys_clk),
    .c0                 (clk_100m),
    .c1                 (clk_100m_shift),
    .c2                 (clk_50m),
    .locked             (locked)
    );

//OV7725配置模块    
ov7725_dri u_ov7725_dri(
    .clk                (clk_50m),   
    .rst_n              (rst_n),   
    .init_done          (cam_init_done),
    .cam_scl            (cam_scl),   
    .cam_sda            (cam_sda)   
);

//CMOS图像数据采集模块
cmos_data_top u_cmos_data_top(
    .rst_n              (rst_n & sys_init_done), //系统初始化完成之后再开始采集数据 
    .cam_pclk           (cam_pclk),
    .cam_vsync          (cam_vsync),
    .cam_href           (cam_href),
    .cam_data           (cam_data),
    .lcd_id             (lcd_id),  
    .h_disp             (h_disp),
    .v_disp             (v_disp),  
    .h_pixel            (h_pixel),
    .v_pixel            (v_pixel),
    .sdram_addr_max     (sdram_addr_max),    
    .cmos_frame_vsync   ( ),
    .cmos_frame_href    ( ),
    .cmos_frame_valid   (cmos_frame_valid),      //数据有效使能信号
    .cmos_frame_data    (wr_data)                //有效数据 
    );

//SDRAM 控制器顶层模块,封装成FIFO接口
//SDRAM 控制器地址组成: {bank_addr[1:0],row_addr[12:0],col_addr[8:0]}
sdram_top u_sdram_top(
    .ref_clk            (clk_100m),             //sdram 控制器参考时钟
    .out_clk            (clk_100m_shift),       //用于输出的相位偏移时钟
    .rst_n              (rst_n),                //系统复位

    //用户写端口                                  
    .wr_clk             (cam_pclk),             //写端口FIFO: 写时钟
    .wr_en              (cmos_frame_valid),     //写端口FIFO: 写使能
    .wr_data            (wr_data),              //写端口FIFO: 写数据
    .wr_min_addr        (24'd0),                //写SDRAM的起始地址
    .wr_max_addr        (sdram_addr_max),       //写SDRAM的结束地址
    .wr_len             (10'd512),              //写SDRAM时的数据突发长度
    .wr_load            (~rst_n),               //写端口复位: 复位写地址,清空写FIFO

    //用户读端口
    .rd_clk             (lcd_clk),              //读端口FIFO: 读时钟
    .rd_en              (rdata_req),            //读端口FIFO: 读使能
    .rd_data            (rd_data),              //读端口FIFO: 读数据
    .rd_min_addr        (24'd0),                //读SDRAM的起始地址
    .rd_max_addr        (sdram_addr_max),       //读SDRAM的结束地址
    .rd_len             (10'd512),              //从SDRAM中读数据时的突发长度
    .rd_load            (~rst_n),               //读端口复位: 复位读地址,清空读FIFO

    //用户控制端口
    .sdram_read_valid   (1'b1),                 //SDRAM 读使能
    .sdram_pingpang_en  (1'b1),                 //SDRAM 乒乓操作使能
    .sdram_init_done    (sdram_init_done),      //SDRAM 初始化完成标志

    //SDRAM 芯片接口
    .sdram_clk          (sdram_clk),            //SDRAM 芯片时钟
    .sdram_cke          (sdram_cke),            //SDRAM 时钟有效
    .sdram_cs_n         (sdram_cs_n),           //SDRAM 片选
    .sdram_ras_n        (sdram_ras_n),          //SDRAM 行有效
    .sdram_cas_n        (sdram_cas_n),          //SDRAM 列有效
    .sdram_we_n         (sdram_we_n),           //SDRAM 写有效
    .sdram_ba           (sdram_ba),             //SDRAM Bank地址
    .sdram_addr         (sdram_addr),           //SDRAM 行/列地址
    .sdram_data         (sdram_data),           //SDRAM 数据
    .sdram_dqm          (sdram_dqm)             //SDRAM 数据掩码
);

//LCD顶层模块
lcd_rgb_top  u_lcd_rgb_top(
    .sys_clk            (clk_50m  ),
    .sys_rst_n          (rst_n ),
    .sys_init_done      (sys_init_done),    
    
    //lcd接口 
    .lcd_id             (lcd_id),                //LCD屏的ID号 
    .lcd_hs             (lcd_hs),                //LCD 行同步信号
    .lcd_vs             (lcd_vs),                //LCD 场同步信号
    .lcd_de             (lcd_de),                //LCD 数据输入使能
    .lcd_rgb            (lcd_rgb),               //LCD 颜色数据
    .lcd_bl             (lcd_bl),                //LCD 背光控制信号
    .lcd_rst            (lcd_rst),               //LCD 复位信号
    .lcd_pclk           (lcd_pclk),              //LCD 采样时钟
    .lcd_clk            (lcd_clk), 	             //LCD 驱动时钟
    //用户接口
    .out_vsync          ( ),                     //lcd场信号
    .h_disp             (h_disp),                //行分辨率  
    .v_disp             (v_disp),                //场分辨率
    .pixel_xpos         (),
    .pixel_ypos         (),    
    .data_in            (rd_data),	             //rfifo输出数据
    .data_req           (rdata_req)              //请求数据输入
);
endmodule