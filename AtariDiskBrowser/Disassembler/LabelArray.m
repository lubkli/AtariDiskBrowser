//
//  LabelDictionary.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "LabelArray.h"

@implementation LabelArray

- (id)init {
    self = [super init];
    if (self) {
        labelArray = [[NSMutableArray<Label*> alloc] init];
        
//        DCB     = $0300         ;DEVICE CONTROL BLOCK
//        DDEVIC  = $0300         ;PERIPHERAL UNIT 1 BUS I.D. NUMBER

        /*
         ;-------------------------------------------------------------------------
         ; Page Two Address Equates
         ;-------------------------------------------------------------------------
         
         INTABS  = $0200         ;INTERRUPT RAM
         
         VDSLST  = $0200         ;DISPLAY LIST NMI VECTOR
         VPRCED  = $0202         ;PROCEED LINE IRQ VECTOR
         VINTER  = $0204         ;INTERRUPT LINE IRQ VECTOR
         VBREAK  = $0206         ;SOFTWARE BREAK (00) INSTRUCTION IRQ VECTOR
         VKEYBD  = $0208         ;POKEY KEYBOARD IRQ VECTOR
         VSERIN  = $020A         ;POKEY SERIAL INPUT READY IRQ
         VSEROR  = $020C         ;POKEY SERIAL OUTPUT READY IRQ
         VSEROC  = $020E         ;POKEY SERIAL OUTPUT COMPLETE IRQ
         VTIMR1  = $0210         ;POKEY TIMER 1 IRQ
         VTIMR2  = $0212         ;POKEY TIMER 2 IRQ
         VTIMR4  = $0214         ;POKEY TIMER 4 IRQ
         VIMIRQ  = $0216         ;IMMEDIATE IRQ VECTOR
         CDTMV1  = $0218         ;COUNT DOWN TIMER 1
         CDTMV2  = $021A         ;COUNT DOWN TIMER 2
         CDTMV3  = $021C         ;COUNT DOWN TIMER 3
         CDTMV4  = $021E         ;COUNT DOWN TIMER 4
         CDTMV5  = $0220         ;COUNT DOWN TIMER 5
         VVBLKI  = $0222         ;IMMEDIATE VERTICAL BLANK NMI VECTOR
         VVBLKD  = $0224         ;DEFERRED VERTICAL BLANK NMI VECTOR
         CDTMA1  = $0226         ;COUNT DOWN TIMER 1 JSR ADDRESS
         CDTMA2  = $0228         ;COUNT DOWN TIMER 2 JSR ADDRESS
         CDTMF3  = $022A         ;COUNT DOWN TIMER 3 FLAG
         SRTIMR  = $022B         ;SOFTWARE REPEAT TIMER
         CDTMF4  = $022C         ;COUNT DOWN TIMER 4 FLAG
         INTEMP  = $022D         ;IAN'S TEMP
         CDTMF5  = $022E         ;COUNT DOWN TIMER FLAG 5
         SDMCTL  = $022F         ;SAVE DMACTL REGISTER
         SDLSTL  = $0230         ;SAVE DISPLAY LIST LOW BYTE
         SDLSTH  = $0231         ;SAVE DISPLAY LIST HI BYTE
         SSKCTL  = $0232         ;SKCTL REGISTER RAM
         LCOUNT  = $0233         ;##1200xl## 1-byte relocating loader record
         LPENH   = $0234         ;LIGHT PEN HORIZONTAL VALUE
         LPENV   = $0235         ;LIGHT PEN VERTICAL VALUE
         BRKKY   = $0236         ;BREAK KEY VECTOR
         ;RELADR = $0238         ;##1200xl## 2-byte relocatable loader address
         VPIRQ   = $0238         ;##rev2## 2-byte parallel device IRQ vector
         CDEVIC  = $023A         ;COMMAND FRAME BUFFER - DEVICE
         CCOMND  = $023B         ;COMMAND
         CAUX1   = $023C         ;COMMAND AUX BYTE 1
         CAUX2   = $023D         ;COMMAND AUX BYTE 2
         
         TEMP    = $023E         ;TEMPORARY RAM CELL
         
         ERRFLG  = $023F         ;ERROR FLAG - ANY DEVICE ERROR EXCEPT TIME OUT
         
         DFLAGS  = $0240         ;DISK FLAGS FROM SECTOR ONE
         DBSECT  = $0241         ;NUMBER OF DISK BOOT SECTORS
         BOOTAD  = $0242         ;ADDRESS WHERE DISK BOOT LOADER WILL BE PUT
         COLDST  = $0244         ;COLDSTART FLAG (1=IN MIDDLE OF COLDSTART>
         RECLEN  = $0245         ;##1200xl## 1-byte relocating loader record length
         DSKTIM  = $0246         ;DISK TIME OUT REGISTER
         ;LINBUF = $0247         ;##old## CHAR LINE BUFFER
         PDVMSK  = $0247         ;##rev2## 1-byte parallel device selection mask
         SHPDVS  = $0248         ;##rev2## 1-byte PDVS (parallel device select)
         PDIMSK  = $0249         ;##rev2## 1-byte parallel device IRQ selection
         RELADR  = $024A         ;##rev2## 2-byte relocating loader relative adr.
         PPTMPA  = $024C         ;##rev2## 1-byte parallel device handler temporary
         PPTMPX  = $024D         ;##rev2## 1-byte parallel device handler temporary
         
         CHSALT  = $026B         ;##1200xl## 1-byte character set alternate
         VSFLAG  = $026C         ;##1200xl## 1-byte fine vertical scroll count
         KEYDIS  = $026D         ;##1200xl## 1-byte keyboard disable
         FINE    = $026E         ;##1200xl## 1-byte fine scrolling mode
         GPRIOR  = $026F         ;GLOBAL PRIORITY CELL
         
         PADDL0  = $0270         ;1-byte potentiometer 0
         PADDL1  = $0271         ;1-byte potentiometer 1
         PADDL2  = $0272         ;1-byte potentiometer 2
         PADDL3  = $0273         ;1-byte potentiometer 3
         PADDL4  = $0274         ;1-byte potentiometer 4
         PADDL5  = $0275         ;1-byte potentiometer 5
         PADDL6  = $0276         ;1-byte potentiometer 6
         PADDL7  = $0277         ;1-byte potentiometer 7
         
         STICK0  = $0278         ;1-byte joystick 0
         STICK1  = $0279         ;1-byte joystick 1
         STICK2  = $027A         ;1-byte joystick 2
         STICK3  = $027B         ;1-byte joystick 3
         
         PTRIG0  = $027C         ;1-byte paddle trigger 0
         PTRIG1  = $027D         ;1-byte paddle trigger 1
         PTRIG2  = $027E         ;1-byte paddle trigger 2
         PTRIG3  = $027F         ;1-byte paddle trigger 3
         PTRIG4  = $0280         ;1-byte paddle trigger 4
         PTRIG5  = $0281         ;1-byte paddle trigger 5
         PTRIG6  = $0281         ;1-byte paddle trigger 6
         PTRIG7  = $0283         ;1-byte paddle trigger 7
         
         STRIG0  = $0284         ;1-byte joystick trigger 0
         STRIG1  = $0285         ;1-byte joystick trigger 1
         STRIG2  = $0286         ;1-byte joystick trigger 2
         STRIG3  = $0287         ;1-byte joystick trigger 3
         
         ;CSTAT  = $0288         ;##old## cassette status register
         HIBYTE  = $0288         ;##1200xl## 1-byte relocating loader high byte
         WMODE   = $0289         ;1-byte cassette WRITE mode
         BLIM    = $028A         ;1-byte cassette buffer limit
         IMASK   = $028B         ;##rev2## (not used)
         JVECK   = $028C         ;2-byte jump vector or temporary
         NEWADR  = $028E         ;##1200xl## 2-byte relocating address
         TXTROW  = $0290         ;TEXT ROWCRS
         TXTCOL  = $0291         ;TEXT COLCRS
         TINDEX  = $0293         ;TEXT INDEX
         TXTMSC  = $0294         ;FOOLS CONVRT INTO NEW MSC
         TXTOLD  = $0296         ;OLDROW & OLDCOL FOR TEXT (AND THEN SOME)
         ;TMPX1  = $029C         ;##old## 1-byte temporary register
         CRETRY  = $029C         ;##1200xl## 1-byte number of command frame retries
         HOLD3   = $029D         ;1-byte temporary
         SUBTMP  = $029E         ;1-byte temporary
         HOLD2   = $029F         ;1-byte (not used)
         DMASK   = $02A0         ;1-byte display (pixel location) mask
         TMPLBT  = $02A1         ;1-byte (not used)
         ESCFLG  = $02A2         ;ESCAPE FLAG
         TABMAP  = $02A3         ;15-byte (120 bit) tab stop bit map
         LOGMAP  = $02B2         ;LOGICAL LINE START BIT MAP
         INVFLG  = $02B6         ;INVERSE VIDEO FLAG (TOGGLED BY ATARI KEY)
         FILFLG  = $02B7         ;RIGHT FILL FLAG FOR DRAW
         TMPROW  = $02B8         ;1-byte temporary row
         TMPCOL  = $02B9         ;2-byte temporary column
         SCRFLG  = $02BB         ;SET IF SCROLL OCCURS
         HOLD4   = $02BC         ;TEMP CELL USED IN DRAW ONLY
         ;HOLD5  = $02BD         ;##old## DITTO
         DRETRY  = $02BD         ;##1200xl## 1-byte number of device retries
         SHFLOK  = $02BE         ;1-byte shift/control lock flags
         BOTSCR  = $02BF         ;BOTTOM OF SCREEN   24 NORM 4 SPLIT
         
         PCOLR0  = $02C0         ;1-byte player-missile 0 color/luminance
         PCOLR1  = $02C1         ;1-byte player-missile 1 color/luminance
         PCOLR2  = $02C2         ;1-byte player-missile 2 color/luminance
         PCOLR3  = $02C3         ;1-byte player-missile 3 color/luminance
         
         COLOR0  = $02C4         ;1-byte playfield 0 color/luminance
         COLOR1  = $02C5         ;1-byte playfield 1 color/luminance
         COLOR2  = $02C6         ;1-byte playfield 2 color/luminance
         COLOR3  = $02C7         ;1-byte playfield 3 color/luminance
         
         COLOR4  = $02C8         ;1-byte background color/luminance
         
         PARMBL  = $02C9         ;##rev2## 6-byte relocating loader parameter
         RUNADR  = $02C9         ;##1200xl## 2-byte run address
         HIUSED  = $02CB         ;##1200xl## 2-byte highest non-zero page address
         ZHIUSE  = $02CD         ;##1200xl## 2-byte highest zero page address
         
         OLDPAR  = $02CF         ;##rev2## 6-byte relocating loader parameter
         GBYTEA  = $02CF         ;##1200xl## 2-byte GET-BYTE routine address
         LOADAD  = $02D1         ;##1200xl## 2-byte non-zero page load address
         ZLOADA  = $02D3         ;##1200xl## 2-byte zero page load address
         
         DSCTLN  = $02D5         ;##1200xl## 2-byte disk sector length
         ACMISR  = $02D7         ;##1200xl## 2-byte ACMI interrupt service routine
         KRPDEL  = $02D9         ;##1200xl## 1-byte auto-repeat delay
         KEYREP  = $02DA         ;##1200xl## 1-byte auto-repeat rate
         NOCLIK  = $02DB         ;##1200xl## 1-byte key click disable
         HELPFG  = $02DC         ;##1200xl## 1-byte HELP key flag (0 = no HELP)
         DMASAV  = $02DD         ;##1200xl## 1-byte SDMCTL save/restore
         PBPNT   = $02DE         ;##1200xl## 1-byte printer buffer pointer
         PBUFSZ  = $02DF         ;##1200xl## 1-byte printer buffer size
         
         GLBABS  = $02E0         ;4-byte global variables for non-DOS users
         RUNAD   = $02E0         ;##map## 2-byte binary file run address
         INITAD  = $02E2         ;##map## 2-byte binary file initialization address
         
         RAMSIZ  = $02E4         ;RAM SIZE (HI BYTE ONLY)
         MEMTOP  = $02E5         ;TOP OF AVAILABLE USER MEMORY
         MEMLO   = $02E7         ;BOTTOM OF AVAILABLE USER MEMORY
         HNDLOD  = $02E9         ;##1200xl## 1-byte user load flag
         DVSTAT  = $02EA         ;STATUS BUFFER
         CBAUDL  = $02EE         ;1-byte low cassette baud rate
         CBAUDH  = $02EF         ;1-byte high cassette baud rate
         CRSINH  = $02F0         ;CURSOR INHIBIT (00 = CURSOR ON)
         KEYDEL  = $02F1         ;KEY DELAY
         CH1     = $02F2         ;1-byte prior keyboard character
         CHACT   = $02F3         ;CHACTL REGISTER RAM
         CHBAS   = $02F4         ;CHBAS REGISTER RAM
         
         NEWROW  = $02F5         ;##1200xl## 1-byte draw destination row
         NEWCOL  = $02F6         ;##1200xl## 2-byte draw destination column
         ROWINC  = $02F8         ;##1200xl## 1-byte draw row increment
         COLINC  = $02F9         ;##1200xl## 1-byte draw column increment
         
         CHAR    = $02FA         ;1-byte internal character
         ATACHR  = $02FB         ;ATASCII CHARACTER
         CH      = $02FC         ;GLOBAL VARIABLE FOR KEYBOARD
         FILDAT  = $02FD         ;RIGHT FILL DATA <DRAW>
         DSPFLG  = $02FE         ;DISPLAY FLAG   DISPLAY CNTLS IF NON-ZERO
         SSFLAG  = $02FF         ;START/STOP FLAG FOR PAGING (CNTL 1). CLEARE
         
         ;-------------------------------------------------------------------------
         ; Page Three Address Equates
         ;-------------------------------------------------------------------------
         
         DCB     = $0300         ;DEVICE CONTROL BLOCK
         DDEVIC  = $0300         ;PERIPHERAL UNIT 1 BUS I.D. NUMBER
         DUNIT   = $0301         ;UNIT NUMBER
         DCOMND  = $0302         ;BUS COMMAND
         DSTATS  = $0303         ;COMMAND TYPE/STATUS RETURN
         DBUFLO  = $0304         ;1-byte low data buffer address
         DBUFHI  = $0305         ;1-byte high data buffer address
         DTIMLO  = $0306         ;DEVICE TIME OUT IN 1 SECOND UNITS
         DUNUSE  = $0307         ;UNUSED BYTE
         DBYTLO  = $0308         ;1-byte low number of bytes to transfer
         DBYTHI  = $0309         ;1-byte high number of bytes to transfer
         DAUX1   = $030A         ;1-byte first command auxiliary
         DAUX2   = $030B         ;1-byte second command auxiliary
         
         TIMER1  = $030C         ;INITIAL TIMER VALUE
         ;ADDCOR = $030E         ;##old## ADDITION CORRECTION
         JMPERS  = $030E         ;##1200xl## 1-byte jumper options
         CASFLG  = $030F         ;CASSETTE MODE WHEN SET
         TIMER2  = $0310         ;2-byte final baud rate timer value
         TEMP1   = $0312         ;TEMPORARY STORAGE REGISTER
         ;TEMP2  = $0314         ;##old## TEMPORARY STORAGE REGISTER
         TEMP2   = $0313         ;##1200xl## 1-byte temporary
         PTIMOT  = $0314         ;##1200xl## 1-byte printer timeout
         TEMP3   = $0315         ;TEMPORARY STORAGE REGISTER
         SAVIO   = $0316         ;SAVE SERIAL IN DATA PORT
         TIMFLG  = $0317         ;TIME OUT FLAG FOR BAUD RATE CORRECTION
         STACKP  = $0318         ;SIO STACK POINTER SAVE CELL
         TSTAT   = $0319         ;TEMPORARY STATUS HOLDER
         
         HATABS  = $031A         ;35-byte handler address table (was 38 bytes)
         PUPBT1  = $033D         ;##1200xl## 1-byte power-up validation byte 1
         PUPBT2  = $033E         ;##1200xl## 1-byte power-up validation byte 2
         PUPBT3  = $033F         ;##1200xl## 1-byte power-up validation byte 3
         
         IOCB    = $0340         ;I/O CONTROL BLOCKS
         ICHID   = $0340         ;HANDLER INDEX NUMBER (FF=IOCB FREE)
         ICDNO   = $0341         ;DEVICE NUMBER (DRIVE NUMBER)
         ICCOM   = $0342         ;COMMAND CODE
         ICSTA   = $0343         ;STATUS OF LAST IOCB ACTION
         ICBAL   = $0344         ;1-byte low buffer address
         ICBAH   = $0345         ;1-byte high buffer address
         ICPTL   = $0346         ;1-byte low PUT-BYTE routine address - 1
         ICPTH   = $0347         ;1-byte high PUT-BYTE routine address - 1
         ICBLL   = $0348         ;1-byte low buffer length
         ICBLH   = $0349         ;1-byte high buffer length
         ICAX1   = $034A         ;1-byte first auxiliary information
         ICAX2   = $034B         ;1-byte second auxiliary information
         ICAX3   = $034C         ;1-byte third auxiliary information
         ICAX4   = $034D         ;1-byte fourth auxiliary information
         ICAX5   = $034E         ;1-byte fifth auxiliary information
         ICSPR   = $034F         ;SPARE BYTE
         
         PRNBUF  = $03C0         ;PRINTER BUFFER
         SUPERF  = $03E8         ;##1200xl## 1-byte editor super function flag
         CKEY    = $03E9         ;##1200xl## 1-byte cassette boot request flag
         CASSBT  = $03EA         ;##1200xl## 1-byte cassette boot flag
         CARTCK  = $03EB         ;##1200xl## 1-byte cartridge equivalence check
         DERRF   = $03EC         ;##rev2## 1-byte screen OPEN error flag
         
         ; Remainder of Page Three Not Cleared upon Reset
         
         ACMVAR  = $03ED         ;##1200xl## 11 bytes reserved for ACMI
         BASICF  = $03F8         ;##rev2## 1-byte BASIC switch flag
         MINTLK  = $03F9         ;##1200xl## 1-byte ACMI module interlock
         GINTLK  = $03FA         ;##1200xl## 1-byte cartridge interlock
         CHLINK  = $03FB         ;##1200xl## 2-byte loaded handler chain link
         CASBUF  = $03FD         ;CASSETTE BUFFER
         
         ;-------------------------------------------------------------------------
         ; Page Four/Five Address Equates
         ;-------------------------------------------------------------------------
         
         ; USER AREA STARTS HERE AND GOES TO END OF PAGE FIVE
         USAREA  = $0480         ;128 bytes reserved for application
         
         LBPR1   = $057E         ;LBUFF PREFIX 1
         LBPR2   = $057F         ;LBUFF PREFIX 2
         LBUFF   = $0580         ;128-byte line buffer
         
         PLYARG  = $05E0         ;6-byte floating point polynomial argument
         FPSCR   = $05E6         ;6-byte floating point temporary
         FPSCR1  = $05EC         ;6-byte floating point temporary
         
         ;LBFEND = $05FF         ;##old## END OF LBUFF
         
         
         DOS     = $0700
         
         ;-------------------------------------------------------------------------
         ; Cartridge Address Equates
         ;-------------------------------------------------------------------------
         
         CARTCS  = $BFFA         ;##rev2## 2-byte cartridge coldstart address
         CART    = $BFFC         ;##rev2## 1-byte cartridge present indicator
         ;0=Cart Exists
         CARTFG  = $BFFD         ;##rev2## 1-byte cartridge flags
         ;D7  0=Not a Diagnostic Cart
         ;    1=Is a Diagnostic cart and control is
         ;      given to cart before any OS is init.
         ;D2  0=Init but Do not Start Cart
         ;    1=Init and Start Cart
         ;D0  0=Do not boot disk
         ;    1=Boot Disk
         CARTAD  = $BFFE         ;##rev2## 2-byte cartridge start vector
         
         ;-------------------------------------------------------------------------
         ; CTIA/GTIA Address Equates
         ;-------------------------------------------------------------------------
         
         GTIA    = $D000         ;CTIA/GTIA area
         
         ; Read/Write Addresses
         
         CONSOL  = GTIA + $1F         ;console switches and speaker control
         
         ; Read Addresses
         
         M0PF    = GTIA + $00         ;missile 0 and playfield collision
         M1PF    = GTIA + $01         ;missile 1 and playfield collision
         M2PF    = GTIA + $02         ;missile 2 and playfield collision
         M3PF    = GTIA + $03         ;missile 3 and playfield collision
         
         P0PF    = GTIA + $04         ;player 0 and playfield collision
         P1PF    = GTIA + $05         ;player 1 and playfield collision
         P2PF    = GTIA + $06         ;player 2 and playfield collision
         P3PF    = GTIA + $07         ;player 3 and playfield collision
         
         M0PL    = GTIA + $08         ;missile 0 and player collision
         M1PL    = GTIA + $09         ;missile 1 and player collision
         M2PL    = GTIA + $0A         ;missile 2 and player collision
         M3PL    = GTIA + $0B         ;missile 3 and player collision
         
         P0PL    = GTIA + $0C         ;player 0 and player collision
         P1PL    = GTIA + $0D         ;player 1 and player collision
         P2PL    = GTIA + $0E         ;player 2 and player collision
         P3PL    = GTIA + $0F         ;player 3 and player collision
         
         TRIG0   = GTIA + $10         ;joystick trigger 0
         TRIG1   = GTIA + $11         ;joystick trigger 1
         
         TRIG2   = GTIA + $12         ;cartridge interlock
         TRIG3   = GTIA + $13         ;ACMI module interlock
         
         PAL     = GTIA + $14         ;##rev2## PAL/NTSC indicator
         
         ; Write Addresses
         
         HPOSP0  = GTIA + $00         ;player 0 horizontal position
         HPOSP1  = GTIA + $01         ;player 1 horizontal position
         HPOSP2  = GTIA + $02         ;player 2 horizontal position
         HPOSP3  = GTIA + $03         ;player 3 horizontal position
         
         HPOSM0  = GTIA + $04         ;missile 0 horizontal position
         HPOSM1  = GTIA + $05         ;missile 1 horizontal position
         HPOSM2  = GTIA + $06         ;missile 2 horizontal position
         HPOSM3  = GTIA + $07         ;missile 3 horizontal position
         
         SIZEP0  = GTIA + $08         ;player 0 size
         SIZEP1  = GTIA + $09         ;player 1 size
         SIZEP2  = GTIA + $0A         ;player 2 size
         SIZEP3  = GTIA + $0B         ;player 3 size
         
         SIZEM   = GTIA + $0C         ;missile sizes
         
         GRAFP0  = GTIA + $0D         ;player 0 graphics
         GRAFP1  = GTIA + $0E         ;player 1 graphics
         GRAFP2  = GTIA + $0F         ;player 2 graphics
         GRAFP3  = GTIA + $10         ;player 3 graphics
         
         GRAFM   = GTIA + $11         ;missile graphics
         
         COLPM0  = GTIA + $12         ;player-missile 0 color/luminance
         COLPM1  = GTIA + $13         ;player-missile 1 color/luminance
         COLPM2  = GTIA + $14         ;player-missile 2 color/luminance
         COLPM3  = GTIA + $15         ;player-missile 3 color/luminance
         
         COLPF0  = GTIA + $16         ;playfield 0 color/luminance
         COLPF1  = GTIA + $17         ;playfield 1 color/luminance
         COLPF2  = GTIA + $18         ;playfield 2 color/luminance
         COLPF3  = GTIA + $19         ;playfield 3 color/luminance
         
         COLBK   = GTIA + $1A         ;background color/luminance
         
         PRIOR   = GTIA + $1B         ;priority select
         VDELAY  = GTIA + $1C         ;vertical delay
         GRACTL  = GTIA + $1D         ;graphic control
         HITCLR  = GTIA + $1E         ;collision clear
         
         ;-------------------------------------------------------------------------
         ; PBI Address Equates
         ;-------------------------------------------------------------------------
         
         PBI     = $D100         ;##rev2## parallel bus interface area
         
         ; Read Addresses
         
         PDVI    = $D1FF         ;##rev2## parallel device IRQ status
         
         ; Write Addresses
         
         PDVS    = $D1FF         ;##rev2## parallel device select
         
         ;-------------------------------------------------------------------------
         ; POKEY Address Equates
         ;-------------------------------------------------------------------------
         
         POKEY     = $D200         ;POKEY area
         
         ; Read Addresses
         
         POT0    = POKEY + $00         ;potentiometer 0
         POT1    = POKEY + $01         ;potentiometer 1
         POT2    = POKEY + $02         ;potentiometer 2
         POT3    = POKEY + $03         ;potentiometer 3
         POT4    = POKEY + $04         ;potentiometer 4
         POT5    = POKEY + $05         ;potentiometer 5
         POT6    = POKEY + $06         ;potentiometer 6
         POT7    = POKEY + $07         ;potentiometer 7
         
         ALLPOT  = POKEY + $08         ;potentiometer port status
         KBCODE  = POKEY + $09         ;keyboard code
         RANDOM  = POKEY + $0A         ;random number generator
         SERIN   = POKEY + $0D         ;serial port input
         IRQST   = POKEY + $0E         ;IRQ interrupt status
         SKSTAT  = POKEY + $0F         ;serial port and keyboard status
         
         ; Write Addresses
         
         AUDF1   = POKEY + $00         ;channel 1 audio frequency
         AUDC1   = POKEY + $01         ;channel 1 audio control
         
         AUDF2   = POKEY + $02         ;channel 2 audio frequency
         AUDC2   = POKEY + $03         ;channel 2 audio control
         
         AUDF3   = POKEY + $04         ;channel 3 audio frequency
         AUDC3   = POKEY + $05         ;channel 3 audio control
         
         AUDF4   = POKEY + $06         ;channel 4 audio frequency
         AUDC4   = POKEY + $07         ;channel 4 audio control
         
         AUDCTL  = POKEY + $08         ;audio control
         STIMER  = POKEY + $09         ;start timers
         SKRES   = POKEY + $0A         ;reset SKSTAT status
         POTGO   = POKEY + $0B         ;start potentiometer scan sequence
         SEROUT  = POKEY + $0D         ;serial port output
         IRQEN   = POKEY + $0E         ;IRQ interrupt enable
         SKCTL   = POKEY + $0F         ;serial port and keyboard control
         
         ;-------------------------------------------------------------------------
         ; ANTIC Address Equates
         ;-------------------------------------------------------------------------
         
         ANTIC     = $D400         ;ANTIC area
         
         ; Read Addresses
         
         VCOUNT  = ANTIC + $0B         ;vertical line counter
         PENH    = ANTIC + $0C         ;light pen horizontal position
         PENV    = ANTIC + $0D         ;light pen vertical position
         NMIST   = ANTIC + $0F         ;NMI interrupt status
         
         ; Write Addresses
         
         DMACTL  = ANTIC + $00         ;DMA control
         CHACTL  = ANTIC + $01         ;character control
         DLISTL  = ANTIC + $02         ;low display list address
         DLISTH  = ANTIC + $03         ;high display list address
         HSCROL  = ANTIC + $04         ;horizontal scroll
         VSCROL  = ANTIC + $05         ;vertical scroll
         PMBASE  = ANTIC + $07         ;player-missile base address
         CHBASE  = ANTIC + $09         ;character base address
         WSYNC   = ANTIC + $0A         ;wait for HBLANK synchronization
         NMIEN   = ANTIC + $0E         ;NMI enable
         NMIRES  = ANTIC + $0F         ;NMI interrupt reset
         
         ; PBI RAM Address Equates
         
         PBIRAM  = $D600         ;##rev2## parallel bus interface RAM area
         
         ; Parallel Device Address Equates
         
         PDID1   = $D803         ;##rev2## parallel device ID 1
         PDIDV   = $D805         ;##rev2## parallel device I/O vector
         PDIRQV  = $D808         ;##rev2## parallel device IRQ vector
         PDID2   = $D80B         ;##rev2## parallel device ID 2
         PDVV    = $D80D         ;##rev2## parallel device vector table
         
         ;-------------------------------------------------------------------------
         ; PIA Address Equates
         ;-------------------------------------------------------------------------
         
         PIA     = $D300         ;PIA area
         
         PORTA   = $D300         ;port A direction register or jacks one/two
         PORTB   = $D301         ;port B direction register or memory management
         
         PACTL   = $D302         ;port A control
         PBCTL   = $D303         ;port B control
         
         ;-------------------------------------------------------------------------
         ; Floating Point Package Address Equates
         ;-------------------------------------------------------------------------
         
         AFP     = $D800         ;convert ASCII to floating point
         FASC    = $D8E6         ;convert floating point to ASCII
         IFP     = $D9AA         ;convert integer to floating point
         FPI     = $D9D2         ;convert floating point to integer
         ZFR0    = $DA44         ;zero FR0
         ZF1     = $DA46         ;zero floating point number
         FSUB    = $DA60         ;subtract floating point numbers
         FADD    = $DA66         ;add floating point numbers
         FMUL    = $DADB         ;multiply floating point numbers
         FDIV    = $DB28         ;divide floating point numbers
         PLYEVL  = $DD40         ;evaluate floating point polynomial
         FLD0R   = $DD89         ;load floating point number
         FLD0P   = $DD8D         ;load floating point number
         FLD1R   = $DD98         ;load floating point number
         PLD1P   = $DD9C         ;load floating point number
         FST0R   = $DDA7         ;store floating point number
         FST0P   = $DDAB         ;store floating point number
         FMOVE   = $DDB6         ;move floating point number
         LOG     = $DECD         ;calculate floating point logarithm
         LOG10   = $DED1         ;calculate floating point base 10 logarithm
         EXP     = $DDC0         ;calculate floating point exponential
         EXP10   = $DDCC         ;calculate floating point base 10 exponential
         
         ;-------------------------------------------------------------------------
         ; Device Handler Vector Table Address Equates
         ;-------------------------------------------------------------------------
         
         EDITRV  = $E400         ;editor handler vector table
         SCRENV  = $E410         ;screen handler vector table
         KEYBDV  = $E420         ;keyboard handler vector table
         PRINTV  = $E430         ;printer handler vector table
         CASETV  = $E440         ;cassette handler vector table
         
         ;-------------------------------------------------------------------------
         ; Jump Vector Address Equates
         ;-------------------------------------------------------------------------
         
         DISKIV  = $E450         ;vector to initialize DIO
         DSKINV  = $E453         ;vector to DIO
         CIOV    = $E456         ;vector to CIO
         SIOV    = $E459         ;vector to SIO
         SETVBV  = $E45C         ;vector to set VBLANK parameters
         
         SYSVBV  = $E45F         ;vector to process immediate VBLANK
         XITVBV  = $E462         ;vector to process deferred VBLANK
         SIOINV  = $E465         ;vector to initialize SIO
         SENDEV  = $E468         ;vector to enable SEND
         INTINV  = $E46B         ;vector to initialize interrupt handler
         CIOINV  = $E46E         ;vector to initialize CIO
         BLKBDV  = $E471         ;vector to power-up display
         WARMSV  = $E474         ;vector to warmstart
         COLDSV  = $E477         ;vector to coldstart
         RBLOKV  = $E47A         ;vector to read cassette block
         CSOPIV  = $E47D         ;vector to open cassette for input
         VCTABL  = $E480         ;RAM vector initial value table
         PUPDIV  = $E480         ;##rev2## vector to power-up display
         SLFTSV  = $E483         ;##rev2## vector to self-test
         PHENTV  = $E486         ;##rev2## vector to enter peripheral handler
         PHUNLV  = $E489         ;##rev2## vector to unlink peripheral handler
         PHINIV  = $E48C         ;##rev2## vector to initialize peripheral handler
         GPDVV   = $E48F         ;##rev2## generic parallel device handler vector
         
         ;-------------------------------------------------------------------------
         ; 6502
         ;-------------------------------------------------------------------------
         NMIVEC  = $FFFA
         RESVEC  = $FFFC
         IRQVEC  = $FFFE
         
         */
        
        [labelArray addObject:[[Label alloc] initWithAddres:0x0300 Label:@"DDEVIC" Comment:@"PERIPHERAL UNIT 1 BUS I.D. NUMBER"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0301 Label:@"DUNIT" Comment:@"UNIT NUMBER"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0302 Label:@"DCOMND" Comment:@"BUS COMMAND"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0303 Label:@"DSTATS" Comment:@"COMMAND TYPE/STATUS RETURN"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0304 Label:@"DBUFLO" Comment:@"1-byte low data buffer address"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0305 Label:@"DBUFHI" Comment:@"1-byte high data buffer address"]];
        
        [labelArray addObject:[[Label alloc] initWithAddres:0x030A Label:@"DAUX1" Comment:@"1-byte first command auxiliary"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x030B Label:@"DAUX2" Comment:@"1-byte second command auxiliary"]];
        
        [labelArray addObject:[[Label alloc] initWithAddres:0x0700 Label:@"BFLAG" Comment:@"Flag ( = 0 )"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0701 Label:@"BRCNT" Comment:@"Number of Consecutive Sectors to Read"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0702 Label:@"BLDADR" Comment:@"Address to Load Boot Sectors at"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0704 Label:@"BIWTARR" Comment:@"Initialization Address"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0706 Label:@"XBCONT" Comment:@"JMP Boot Continue Vector"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0709 Label:@"SABYTE" Comment:@"Number of Sector Buffers to Allocate"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x070A Label:@"DRVBYT" Comment:@"Drive Bits"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x070C Label:@"SASA" Comment:@"Buffer Start Address"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x070E Label:@"DFSFLG" Comment:@"DOS Flag"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x070F Label:@"DFLINK" Comment:@"Sector Pointer to DOS.SYS File"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0711 Label:@"BLDISP" Comment:@"Displacement in Sector to Sector Link"]];
        [labelArray addObject:[[Label alloc] initWithAddres:0x0712 Label:@"DFLADR" Comment:@"Address os Start of DOS.SYS File"]];
    }
    return self;
}

- (NSString *)getAddress:(NSString *)format forHighByte:(const unsigned char)highByte andLowByte:(const unsigned char)lowByte {
    
    NSString *valueString = [NSString stringWithFormat:@"0x%02X%02X", highByte, lowByte];
    
    NSString *predString = [NSString stringWithFormat:@"(address == %@)", valueString];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:predString];
    
    NSArray *array = [labelArray filteredArrayUsingPredicate:pred];
    
    if (array.count == 0)
    {
        return [NSString stringWithFormat:format, highByte, lowByte];
    }
    else
    {
        Label *label = array[0];
        return [NSString stringWithFormat:@"%@ ; %@", label.label, label.comment];
    }
}

@end
