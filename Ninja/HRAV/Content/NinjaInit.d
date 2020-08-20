/*
 * Convert hexadecimal to decimal
 */
func int Ninja_HRAV_HexToDec(var string hex) {
    var zString str; str = _^(_@s(hex));

    // Consider the last 4 bytes only
    if (str.len > 8) {
        hex = STR_SubStr(hex, str.len-8, 8);
    };

    // Iterate over all characters (from back to front)
    var int dec; dec = 0;
    repeat(i, str.len); var int i;
        dec += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr+(str.len-1)-i)) << 4*i;
    end;

    return dec+0;
};


/*
 * Parse and replace stack trace line of access violation report
 */
func void Ninja_HRAV_ParseLine() {
    if (!ESI) {
        return;
    };
    var string line; line = STR_FromChar(ESI);

    // Check minimum length
    if (STR_Len(line) < 73 + 30) {
        return;
    };

    // Extract module name
    var int pos; pos = STR_IndexOf(line, ",");
    if (pos == -1) {
        return;
    };
    var string module; module = STR_SubStr(line, 60, pos-60);

    // Verify module is Gothic
    var string thisModule;
    if (GOTHIC_BASE_VERSION == 1) {
        thisModule = "GothicMod.exe";
    } else {
        thisModule = "Gothic2.exe";
    };
    if (!Hlp_StrCmp(module, thisModule)) {
        return;
    };

    // Retrieve addresses/values on the stack
    var int addr;    addr    = Ninja_HRAV_HexToDec(STR_SubStr(line,  5,  8));
    var int stack1;  stack1  = Ninja_HRAV_HexToDec(STR_SubStr(line, 17,  8));
    var int stack2;  stack2  = Ninja_HRAV_HexToDec(STR_SubStr(line, 28,  8));
    var int stack3;  stack3  = Ninja_HRAV_HexToDec(STR_SubStr(line, 39,  8));

    // Check if in Daedalus function (specific to Gothic 2 due to bytes check)
    var int symbId;
    var int codeStackPos; codeStackPos = 0;
    var string origin; origin = thisModule;
    pos += 2;
    if (Hlp_StrCmp(STR_SubStr(line, pos, STR_Len(DoStack_Name)), DoStack_Name)) {
        codeStackPos = stack1;
        symbId = MEM_GetFuncIDByOffset(codeStackPos);
        origin = "Daedalus";
    } else if (Hlp_StrCmp(STR_SubStr(line, pos, STR_Len(CallFunc_Name)), CallFunc_Name))
           && (stack1 == ContentParserAddress) {
        symbId = stack2;
    } else if (Hlp_StrCmp(STR_SubStr(line, pos, STR_Len(CreateInstance_Name)), CreateInstance_Name)) {
        symbId = stack3;
    } else {
        return;
    };

    // Get symbol name
    var string location;
    if (symbId < 0 || symbId >= currSymbolTableLength) {
        location = "[UNKNOWN]";
    } else {
        var zCPar_Symbol symb; symb = _^(MEM_GetSymbolByIndex(symbId));
        location = ConcatStrings(STR_Lower(symb.name), "()");
        if (codeStackPos) {
            var int diff; diff = codeStackPos - symb.content;
            if (diff >= 0) {
                location = ConcatStrings(location, "+");
            };
            location = ConcatStrings(location, IntToString(diff));
            location = ConcatStrings(location, " byte(s)");
        };
    };
    location = ConcatStrings(location, " ");

    // Get token (not fully confirmed for Gothic 1)
    var string token; token = "";
    if (codeStackPos) {
             if (zCParser__DoStack+ 351 < addr) && (addr < zCParser__DoStack+ 366) { token = "zPAR_TOK_PUSHINT";       }
        else if (zCParser__DoStack+ 366 < addr) && (addr < zCParser__DoStack+ 385) { token = "zPAR_TOK_PUSHVAR";       }
        else if (zCParser__DoStack+ 415 < addr) && (addr < zCParser__DoStack+ 449) { token = "zPAR_TOK_PUSH_ARRAYVAR"; }
        else if (zCParser__DoStack+ 449 < addr) && (addr < zCParser__DoStack+ 538) { token = "zPAR_OP_IS";             }
        else if (zCParser__DoStack+ 538 < addr) && (addr < zCParser__DoStack+ 631) { token = "zPAR_OP_ISPLUS";         }
        else if (zCParser__DoStack+ 631 < addr) && (addr < zCParser__DoStack+ 724) { token = "zPAR_OP_ISMINUS";        }
        else if (zCParser__DoStack+ 724 < addr) && (addr < zCParser__DoStack+ 828) { token = "zPAR_OP_ISMUL";          }
        else if (zCParser__DoStack+ 828 < addr) && (addr < zCParser__DoStack+ 934) { token = "zPAR_OP_ISDIV";          }
        else if (zCParser__DoStack+ 934 < addr) && (addr < zCParser__DoStack+1034) { token = "zPAR_OP_PLUS";           }
        else if (zCParser__DoStack+1034 < addr) && (addr < zCParser__DoStack+1137) { token = "zPAR_OP_MINUS";          }
        else if (zCParser__DoStack+1137 < addr) && (addr < zCParser__DoStack+1240) { token = "zPAR_OP_MUL";            }
        else if (zCParser__DoStack+1240 < addr) && (addr < zCParser__DoStack+1351) { token = "zPAR_OP_DIV";            }
        else if (zCParser__DoStack+1351 < addr) && (addr < zCParser__DoStack+1465) { token = "zPAR_OP_MOD";            }
        else if (zCParser__DoStack+1465 < addr) && (addr < zCParser__DoStack+1565) { token = "zPAR_OP_OR";             }
        else if (zCParser__DoStack+1565 < addr) && (addr < zCParser__DoStack+1665) { token = "zPAR_OP_AND";            }
        else if (zCParser__DoStack+1665 < addr) && (addr < zCParser__DoStack+1783) { token = "zPAR_OP_LOWER";          }
        else if (zCParser__DoStack+1783 < addr) && (addr < zCParser__DoStack+1901) { token = "zPAR_OP_HIGHER";         }
        else if (zCParser__DoStack+1901 < addr) && (addr < zCParser__DoStack+1999) { token = "zPAR_OP_LOG_OR";         }
        else if (zCParser__DoStack+1999 < addr) && (addr < zCParser__DoStack+2090) { token = "zPAR_OP_LOG_AND";        }
        else if (zCParser__DoStack+2100 < addr) && (addr < zCParser__DoStack+2209) { token = "zPAR_OP_SHIFTL";         }
        else if (zCParser__DoStack+2209 < addr) && (addr < zCParser__DoStack+2318) { token = "zPAR_OP_SHIFTR";         }
        else if (zCParser__DoStack+2318 < addr) && (addr < zCParser__DoStack+2436) { token = "zPAR_OP_LOWER_EQ";       }
        else if (zCParser__DoStack+2436 < addr) && (addr < zCParser__DoStack+2554) { token = "zPAR_OP_EQUAL";          }
        else if (zCParser__DoStack+2554 < addr) && (addr < zCParser__DoStack+2672) { token = "zPAR_OP_NOTEQUAL";       }
        else if (zCParser__DoStack+2672 < addr) && (addr < zCParser__DoStack+2787) { token = "zPAR_OP_HIGHER_EQ";      }
        else if (zCParser__DoStack+2787 < addr) && (addr < zCParser__DoStack+2837) { token = "zPAR_OP_UN_MINUS";       }
        else if (zCParser__DoStack+2837 < addr) && (addr < zCParser__DoStack+2882) { token = "zPAR_OP_UN_PLUS";        }
        else if (zCParser__DoStack+2881 < addr) && (addr < zCParser__DoStack+2898) { token = "zPAR_OP_UN_NOT";         }
        else if (zCParser__DoStack+2898 < addr) && (addr < zCParser__DoStack+2910) { token = "zPAR_OP_UN_NEG";         }
        else if (zCParser__DoStack+2932 < addr) && (addr < zCParser__DoStack+2999) { token = "zPAR_TOK_CALL";          }
        else if (zCParser__DoStack+2999 < addr) && (addr < zCParser__DoStack+3119) { token = "zPAR_TOK_CALLEXTERN";    }
        else if (zCParser__DoStack+3119 < addr) && (addr < zCParser__DoStack+3139) { token = "zPAR_TOK_JUMP";          }
        else if (zCParser__DoStack+3139 < addr) && (addr < zCParser__DoStack+3182) { token = "zPAR_TOK_JUMPF";         }
        else if (zCParser__DoStack+3182 < addr) && (addr < zCParser__DoStack+3212) { token = "zPAR_TOK_SETINSTANCE";   }
        else if (zCParser__DoStack+3212 < addr) && (addr < zCParser__DoStack+3300) { token = "zPAR_TOK_ASSIGNSTR";     }
        else if (zCParser__DoStack+3300 < addr) && (addr < zCParser__DoStack+3333) { token = "zPAR_TOK_ASSIGNSTRP";    }
        else if (zCParser__DoStack+3333 < addr) && (addr < zCParser__DoStack+3356) { token = "zPAR_TOK_ASSIGNFUNC";    }
        else if (zCParser__DoStack+3356 < addr) && (addr < zCParser__DoStack+3379) { token = "zPAR_TOK_ASSIGNFLOAT";   }
        else if (zCParser__DoStack+3379 < addr) && (addr < zCParser__DoStack+3400) { token = "zPAR_TOK_PUSHINST";      }
        else if (zCParser__DoStack+3400 < addr) && (addr < zCParser__DoStack+3463) { token = "zPAR_TOK_ASSIGNINST";    }
        else if (zCParser__DoStack+3463 < addr) && (addr < zCParser__DoStack+3515) { token = "INVALID_TOKEN";          }
        else if (zCParser__DoStack+3515 < addr) && (addr < zCParser__DoStack+3533) { token = "zPAR_TOK_RET";           }
        else    { token = "UNKNOWN"; };

        token = ConcatStrings(ConcatStrings("[", token), "] ");
    };
    location = ConcatStrings(location, token);
    location = ConcatStrings(location, "in ");

    // Create new output
    var string prefix;  prefix  = ConcatStrings(STR_Prefix(line, 60), ConcatStrings(origin, ", "));
    var string suffix;  suffix  = STR_SubStr(line, 60, STR_Len(line)-60);
    var string newline; newline = ConcatStrings(ConcatStrings(prefix, location), suffix);

    // Overwrite output
    MEM_Free(ESI);
    ESI = MEM_Alloc(STR_Len(newline) + 1);
    MEM_CopyBytes(STR_toChar(newline), ESI, STR_Len(newline));
};


/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_HRAV_Menu(var int menuPtr) {
    // Initialize Ikarus
    MEM_InitAll();

    // Ensure latest Ikarus changes
    if (!MEM_CheckVersion(1, 2, 2)) {
        MEM_SendToSpy(zERR_TYPE_FATAL, "HRAV requires at least Ninja 2.1.02 or higher.");
    };

    // Hook into exception handler
    const int zCExceptionHandler__UnhandledExceptionFilter_print_G1 = 4978965; //0x4BF915
    const int zCExceptionHandler__UnhandledExceptionFilter_print_G2 = 5016696; //0x4C8C78
    HookEngineF(MEMINT_SwitchG1G2(zCExceptionHandler__UnhandledExceptionFilter_print_G1,
                                  zCExceptionHandler__UnhandledExceptionFilter_print_G2), 5, Ninja_HRAV_ParseLine);
};
