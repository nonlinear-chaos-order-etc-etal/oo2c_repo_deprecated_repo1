static void* _c0;
static void* _c1;
static void* _c2;
static void* _c3;
static void* _c4;
static void* _c5;
static void* _c6;
static void* _c7;
static void* _c8;
static void* _c9;
static void* _c10;
static void* _c11;
static void* _c12;
static void* _c13;
static void* _c14;
static void* _c15;
static void* _c16;
static void* _c17;
static void* _c18;
#include <IO/TextRider.oh>
#include <Exception.oh>
#include <Strings.oh>
#include <RealStr.oh>
#include <IntStr.oh>
static void IO_TextRider__SetError(IO_TextRider__Writer w);
static void IO_TextRider__WritePad(IO_TextRider__Writer w, OOC_INT32 n);
static OOC_CHAR8 IO_TextRider__HexDigit(OOC_CHAR8 ch);
static OOC_CHAR8 IO_TextRider__HexToInt(const OOC_CHAR8 str__ref[], OOC_LEN str_0d, OOC_INT32 *lint);

/* run-time meta data */
static RT0__ModuleDesc _mid;
RT0__StructDesc _td_IO_TextRider__OverflowError = { (RT0__Struct[]){&_td_IO_TextRider__OverflowErrorDesc}, NULL, NULL, &_mid, "OverflowError", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_IO_TextRider__OverflowErrorDesc = { (RT0__Struct[]){&_td_Exception__ExceptionDesc,&_td_Exception__CheckedDesc,&_td_IO__ErrorDesc,&_td_IO_TextRider__OverflowErrorDesc}, (void*[]){(void*)IO__ErrorDesc_INIT,(void*)Exception__ExceptionDesc_GetMessage,(void*)Exception__ExceptionDesc_WriteBacktrace,(void*)Exception__ExceptionDesc_Name}, NULL, &_mid, "OverflowErrorDesc", 92, 3, 0, RT0__strRecord };
RT0__StructDesc _td_IO_TextRider__Writer = { (RT0__Struct[]){&_td_IO_TextRider__WriterDesc}, NULL, NULL, &_mid, "Writer", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_IO_TextRider__WriterDesc = { (RT0__Struct[]){&_td_IO_TextRider__WriterDesc}, (void*[]){(void*)IO_TextRider__WriterDesc_SetEol,(void*)IO_TextRider__WriterDesc_WriteString,(void*)IO_TextRider__WriterDesc_WriteStringRegion,(void*)IO_TextRider__WriterDesc_WriteObject,(void*)IO_TextRider__WriterDesc_WriteBool,(void*)IO_TextRider__WriterDesc_WriteChar,(void*)IO_TextRider__WriterDesc_WriteLInt,(void*)IO_TextRider__WriterDesc_WriteSInt,(void*)IO_TextRider__WriterDesc_WriteInt,(void*)IO_TextRider__WriterDesc_WriteHex,(void*)IO_TextRider__WriterDesc_WriteLReal,(void*)IO_TextRider__WriterDesc_WriteReal,(void*)IO_TextRider__WriterDesc_WriteLRealFix,(void*)IO_TextRider__WriterDesc_WriteRealFix,(void*)IO_TextRider__WriterDesc_WriteLRealEng,(void*)IO_TextRider__WriterDesc_WriteRealEng,(void*)IO_TextRider__WriterDesc_WriteSet,(void*)IO_TextRider__WriterDesc_WriteLn}, NULL, &_mid, "WriterDesc", 12, 0, 0, RT0__strRecord };
RT0__StructDesc _td_IO_TextRider__2386 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 2, 2, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__2565 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__Buffer = { (RT0__Struct[]){&_td_IO_TextRider__2565}, NULL, NULL, &_mid, "Buffer", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_IO_TextRider__Reader = { (RT0__Struct[]){&_td_IO_TextRider__ReaderDesc}, NULL, NULL, &_mid, "Reader", 4, -1, 0, RT0__strPointer };
RT0__StructDesc _td_IO_TextRider__ReaderDesc = { (RT0__Struct[]){&_td_IO_TextRider__ReaderDesc}, (void*[]){(void*)IO_TextRider__ReaderDesc_INIT,(void*)IO_TextRider__ReaderDesc_SetEOL,(void*)IO_TextRider__ReaderDesc_AquireBufferWithSize,(void*)IO_TextRider__ReaderDesc_ReadLineBuffer,(void*)IO_TextRider__ReaderDesc_ConsumeWhiteSpace,(void*)IO_TextRider__ReaderDesc_ReadChar,(void*)IO_TextRider__ReaderDesc_ReadString,(void*)IO_TextRider__ReaderDesc_ReadLInt,(void*)IO_TextRider__ReaderDesc_ReadInt,(void*)IO_TextRider__ReaderDesc_ReadSInt,(void*)IO_TextRider__ReaderDesc_ReadIdentifier,(void*)IO_TextRider__ReaderDesc_ReadBool,(void*)IO_TextRider__ReaderDesc_ReadHex,(void*)IO_TextRider__ReaderDesc_ReadLn,(void*)IO_TextRider__ReaderDesc_ReadLine}, NULL, &_mid, "ReaderDesc", 24, 0, 0, RT0__strRecord };
RT0__StructDesc _td_IO_TextRider__4758 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__5664 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__5913 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__7527 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 16, 16, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__8990 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__9359 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__9798 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__10175 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__10615 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__10990 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 128, 128, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__17274 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__21188 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__22505 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 8, 8, (1<<RT0__flagAtomic), RT0__strArray };
RT0__StructDesc _td_IO_TextRider__22892 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
RT0__StructDesc _td_IO_TextRider__25952 = { (RT0__Struct[]){&RT0__char}, NULL, NULL, &_mid, NULL, 1, 1, (1<<RT0__flagAtomic), RT0__strOpenArray };
static RT0__ModuleDesc _mid = { (OOC_CHAR8*)"IO:TextRider", (RT0__Struct[]) { &_td_IO_TextRider__OverflowError, &_td_IO_TextRider__OverflowErrorDesc, &_td_IO_TextRider__Writer, &_td_IO_TextRider__WriterDesc, &_td_IO_TextRider__Buffer, &_td_IO_TextRider__Reader, &_td_IO_TextRider__ReaderDesc, NULL } };

extern void OOC_IO_TextRider_init0() {
  RT0__RegisterModule(&_mid);
  OOC_IO_TextRider_init();
}

/* --- */