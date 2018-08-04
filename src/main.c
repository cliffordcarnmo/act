#include <stdlib.h>
#include <stdio.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <graphics/gfxmacros.h>
#include <exec/types.h>
#include <exec/memory.h>

struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
static struct UCopList *copper;
static struct RastPort *rp;
static struct Screen *myScreen;
static struct NewScreen Screen1 = {
	.LeftEdge = 0,
	.TopEdge = 0,
	.Width = 640,
	.Height = 256,
	.Depth = 2,
	.DetailPen = DETAILPEN,
	.BlockPen = BLOCKPEN,
	.ViewModes = HIRES,
	.Type = CUSTOMSCREEN | SCREENQUIET,
	.Font = &(struct TextAttr){
		.ta_Name = "topaz.font",
		.ta_YSize = 8,
		.ta_Style = 0,
		.ta_Flags = 0,
	},
	.DefaultTitle = NULL, 
	.Gadgets = NULL,
	.CustomBitMap = NULL
};

static UWORD empty[4] = {
	0x0000, 0x0000,
	0x0000, 0x0000
};

int main(int argc, char **argv)
{
	struct Task *current_task = FindTask(NULL);
	BYTE old_prio = SetTaskPri(current_task, 127);

	Forbid();

	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
	copper = (struct UCopList *)AllocMem(sizeof(struct UCopList), MEMF_PUBLIC|MEMF_CHIP|MEMF_CLEAR);

	myScreen = OpenScreen(&Screen1);
	rp = &myScreen->RastPort;

	CINIT(copper, 24);
	CMOVE(copper, *((UWORD *)0xDFF122), (LONG)empty);
	CWAIT(copper, 1, 0);
	CMOVE(copper, *((UWORD *)0xDFF182), 0xfff);
	CMOVE(copper, *((UWORD *)0xDFF180), 0x446);
	CEND(copper);

	myScreen->ViewPort.UCopIns = copper;
	RethinkDisplay();

	while(1){
		SetAPen(rp, 1);
		Move(rp, 265, 130);
		Text(rp, "Hello, World!", 13);
	}

	CloseScreen(myScreen);
	CloseLibrary((struct Library *)IntuitionBase);
	CloseLibrary((struct Library *)GfxBase);

	Permit();

	return 0;
}