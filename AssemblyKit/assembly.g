@prefixForRadix = '0x' 16;
@prefixForRadix = '$'  16;
@prefixForRadix = '%'   2;

@numberState = '$';
@numberState = '%';

@groupingSeparatorForRadix = '_' 16;
@groupingSeparatorForRadix = '_' 10;
@groupingSeparatorForRadix = '_'  2;

@singleLineComments = '//';
@multiLineComments  = '/*' '*/';

@start      = stat+;
stat        = [instruction semi];
constant    = Number;

// Registers
reg8Bit     = 'ah' | 'al' | 'bh' | 'bl' | 'ch' | 'cl' | 'dh' | 'dl';
reg16Bit    = 'ax' | 'bx' | 'cx' | 'dx' | 'si' | 'di' | 'bp' | 'sp';
reg32Bit    = 'eax' | 'ebx' | 'ecx'| 'edx' | 'esi' | 'edi' | 'ebp' | 'esp';
register    = reg8Bit | reg16Bit | reg32Bit;


// Memory
reg32Ptr       = [openBracket reg32Bit closeBracket];
memRegIndirect = reg32Ptr;
memIndexed     = constant reg32Ptr;
mem            = memRegIndirect | memIndexed;


// Instructions
instruction = [func openParen (argList | Empty) closeParen];
func        = 'mov' | 'and' | 'or' | 'xor' | 'neg' | 'not' | 'shl' | 'shr' | 'push' | 'pop';
argList     = arg ([comma arg])*;
arg         = constant | register | mem;

semi         = Symbol(';')!;
openParen    = Symbol('('); // don't discard
closeParen   = Symbol(')')!;
comma        = Symbol(',')!;
openBracket  = Symbol('[')!;
closeBracket = Symbol(']')!;
