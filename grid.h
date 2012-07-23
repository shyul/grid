#define GBASE_SYS_ID					(unsigned int)(0x10000000)
#define gSYS_ID 						(*(volatile unsigned short *)(GBASE_SYS_ID + 0x0))
#define gSYS_ID_FLAG					(*(volatile unsigned short *)(GBASE_SYS_ID + 0x2))
#define gSYS_ID_VER 					(*(volatile unsigned int *)(GBASE_SYS_ID + 0x4))
#define gSYS_ID_LOCK					(*(volatile unsigned int *)(GBASE_SYS_ID + 0x8))
#define gSYS_ID_LOCKB					(*(volatile unsigned int *)(GBASE_SYS_ID + 0xC))

#define GBASE_FUNC_LED					(unsigned int)(0x10000100)
#define gFUNC_LED_B(ch)					(*(volatile unsigned char *)(GBASE_FUNC_LED + 0x0 + 0x4 * ch))
#define gFUNC_LED_G(ch)					(*(volatile unsigned char *)(GBASE_FUNC_LED + 0x1 + 0x4 * ch))
#define gFUNC_LED_R(ch)					(*(volatile unsigned char *)(GBASE_FUNC_LED + 0x2 + 0x4 * ch))
#define gFUNC_LED_S(ch)					(*(volatile unsigned char *)(GBASE_FUNC_LED + 0x3 + 0x4 * ch))

#define GBASE_SHIELD_CTRL				(unsigned int)(0x10000200)
#define gSHIELD_CTRL_OC					(*(volatile unsigned char *)(GBASE_SHIELD_CTRL + 0x0))
#define gSHIELD_CTRL_OEL				(*(volatile unsigned char *)(GBASE_SHIELD_CTRL + 0x1))
#define gSHIELD_CTRL_OEH				(*(volatile unsigned char *)(GBASE_SHIELD_CTRL + 0x2))
#define gSHIELD_CTRL_PWREN				(*(volatile unsigned char *)(GBASE_SHIELD_CTRL + 0x3))

#define grid_func_led_set(ch, r, g, b)	{gFUNC_LED_S(ch) = (unsigned char)(0x00); gFUNC_LED_R(ch) = (unsigned char)r; gFUNC_LED_G(ch) = (unsigned char)g; gFUNC_LED_B(ch) = (unsigned char)b;}
#define grid_func_led_asi(ch)			{gFUNC_LED_S(ch) = (unsigned char)(0x80);}	// Set LED controlled by external module
#define grid_func_led_usr(ch)			{gFUNC_LED_S(ch) = (unsigned char)(0x00);}	// Set LED controlled by register values

#define grid_shield_a_lo_en()			{gSHIELD_CTRL_OEL |= (1 << 0);}
#define grid_shield_a_hi_en()			{gSHIELD_CTRL_OEH |= (1 << 0);}
#define grid_shield_b_lo_en()			{gSHIELD_CTRL_OEL |= (1 << 1);}
#define grid_shield_b_hi_en()			{gSHIELD_CTRL_OEH |= (1 << 1);}
#define grid_shield_a_pwr_en()			{gSHIELD_CTRL_PWREN |= (1 << 0);}
#define grid_shield_b_pwr_en()			{gSHIELD_CTRL_PWREN |= (1 << 1);}
#define grid_shield_a_lo_dis()			{gSHIELD_CTRL_OEL &= ~(1 << 0);}
#define grid_shield_a_hi_dis()			{gSHIELD_CTRL_OEH &= ~(1 << 0);}
#define grid_shield_b_lo_dis()			{gSHIELD_CTRL_OEL &= ~(1 << 1);}
#define grid_shield_b_hi_dis()			{gSHIELD_CTRL_OEH &= ~(1 << 1);}
#define grid_shield_a_pwr_dis()			{gSHIELD_CTRL_PWREN &= ~(1 << 0);}
#define grid_shield_b_pwr_dis()			{gSHIELD_CTRL_PWREN &= ~(1 << 1);}

struct grid_pio26{
unsigned int GRID_MOD_SIZE		0x0
unsigned int GRID_MOD_ID		0x4
unsigned int PIO_DOUT			0x8
unsigned int PIO_DIN			0xC
unsigned int PIO_DOE			0x10
unsigned int resv				0x14
unsigned int resv				0x18
unsigned int resv				0x1C
unsigned int PIO_IMASK			0x20
 * PIO_ICLR				0x24
 * PIO_IE				0x28
 * PIO_IINV				0x2C
 * PIO_IEDGE			0x30
 * resv					0x34
 * resv					0x38
 * resv					0x3C
 * PIO_IO0				0x40
 * PIO_IO1				0x41
 * PIO_IO2				0x42
 * PIO_IO3				0x43
 * PIO_IO4				0x44
 * PIO_IO5				0x45
 * PIO_IO6				0x46
 * PIO_IO7				0x47
 * PIO_IO8				0x48
 * PIO_IO9				0x49
 * PIO_IO10				0x4A
 * PIO_IO11				0x4B
 * PIO_IO12				0x4C
 * PIO_IO13				0x4D
 * PIO_IO14				0x4E
 * PIO_IO15				0x4F
 * PIO_IO16				0x50
 * PIO_IO17				0x51
 * PIO_IO18				0x52
 * PIO_IO19				0x53
 * PIO_IO20				0x54
 * PIO_IO21				0x55
 * PIO_IO22				0x56
 * PIO_IO23				0x57
 * PIO_IO24				0x58
 * PIO_IO25				0x59





};


#define GBASE_GRID_PIO26			(unsigned int)(0x20000000)


#define GBASE_PWM_CH0				(unsigned int)(0x)