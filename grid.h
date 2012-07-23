#define GBASE_SYS_ID				(U32)(0x10000000)
#define gSYS_ID 					(*(volatile U16 *)(GBASE_SYS_ID))
#define gSYS_ID_FLAG				(*(volatile U16 *)(GBASE_SYS_ID + 0x2))
#define gSYS_ID_VER 				(*(volatile U32 *)(GBASE_SYS_ID + 0x4))
#define gSYS_ID_LOCK				(*(volatile U16 *)(GBASE_SYS_ID + 0x8))
#define gSYS_ID_LOCKB				(*(volatile U16 *)(GBASE_SYS_ID + 0xC))

#define GBASE_FUNC_LED				(U32)(0x10000100)
#define gFUNC_B(ch)					(*(volatile U8 *)(GBASE_FUNC_LED + 0x0 + 0x4 * ch))
#define gFUNC_G(ch)					(*(volatile U8 *)(GBASE_FUNC_LED + 0x1 + 0x4 * ch))
#define gFUNC_R(ch)					(*(volatile U8 *)(GBASE_FUNC_LED + 0x2 + 0x4 * ch))
#define gFUNC_S(ch)					(*(volatile U8 *)(GBASE_FUNC_LED + 0x3 + 0x4 * ch))

#define grid_set_func_led(ch, r, g, b)	{gFUNC_R(ch) = (U8)r; gFUNC_G(ch) = (U8)g; gFUNC_B(ch) = (U8)b;}
#define grid_func_led_asi(ch)			{gFUNC_S(ch) = (U8)(0x80);}	// Set LED controlled by external module
#define grid_func_led_usr(ch)			{gFUNC_S(ch) = (U8)(0x00);}	// Set LED controlled by register values

#define GBASE_SLOT_CTRL				(U32)(0x10000200)











#define GBASE_GRID_PIO26			(U32)(0x20000000)


#define GBASE_PWM_CH0				(U32)(0x)