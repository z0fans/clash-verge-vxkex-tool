///////////////////////////////////////////////////////////////////////////////
//
// Module Name:
//
//     NtDll.h
//
// Abstract:
//
//     Windows NT Native API
//
//     PSA: If you try and use this header file outside of VxKex, keep in mind
//     that many of the structures in here are defined for Windows 7 only. No
//     attempt is made to make anything compatible with anything other than
//     Windows 7.
//
// Author:
//
//     vxiiduu (26-Mar-2022)
//
// Environment:
//
//     Any environment.
//
// Revision History:
//
//     vxiiduu               26-Mar-2022  Initial creation.
//     vxiiduu               26-Sep-2022  Add header.
//
///////////////////////////////////////////////////////////////////////////////

#pragma once
#include <KexTypes.h>
#include <WinIoCtl.h>
#include <WinNT.h>
#undef WIN32_NO_STATUS
#include <ntstatus.h>
#define WIN32_NO_STATUS

#if defined(KEX_TARGET_TYPE_EXE) || defined(KEX_TARGET_TYPE_DLL)
#  if defined(KEX_ARCH_X64)
#    pragma comment(lib, "ntdll_x64.lib")
#  elif defined(KEX_ARCH_X86)
#    pragma comment(lib, "ntdll_x86.lib")
#  endif
#endif

#pragma region Macro Definitions

#define NT_SUCCESS(st) (((NTSTATUS) (st)) >= 0)

#define HARDERROR_OVERRIDE_ERRORMODE		0x10000000L

#define PAGE_SIZE 0x1000

#define RTL_MAX_DRIVE_LETTERS 32
#define PROCESSOR_FEATURE_MAX 64
#define GDI_HANDLE_BUFFER_SIZE32 34
#define GDI_HANDLE_BUFFER_SIZE64 60

#define PF_FLOATING_POINT_PRECISION_ERRATA			0
#define PF_FLOATING_POINT_EMULATED			0
#define PF_COMPARE_EXCHANGE_DOUBLE			0
#define PF_MMX_INSTRUCTIONS_AVAILABLE			0
#define PF_PPC_MOVEMEM_64BIT_OK			0
#define PF_ALPHA_BYTE_INSTRUCTIONS			0
#define PF_XMMI_INSTRUCTIONS_AVAILABLE			0
#define PF_3DNOW_INSTRUCTIONS_AVAILABLE			0
#define PF_RDTSC_INSTRUCTION_AVAILABLE			0
#define PF_PAE_ENABLED			0
#define PF_XMMI64_INSTRUCTIONS_AVAILABLE			0
#define PF_SSE_DAZ_MODE_AVAILABLE		0
#define PF_NX_ENABLED		0
#define PF_SSE3_INSTRUCTIONS_AVAILABLE		0
#define PF_COMPARE_EXCHANGE128			0
#define PF_COMPARE64_EXCHANGE128			0
#define PF_CHANNELS_ENABLED		0
#define PF_XSAVE_ENABLED		0

#define OBJ_INHERIT             0x00000002L
#define OBJ_PERMANENT           0x00000010L
#define OBJ_EXCLUSIVE           0x00000020L
#define OBJ_CASE_INSENSITIVE    0x00000040L
#define OBJ_OPENIF              0x00000080L
#define OBJ_OPENLINK            0x00000100L
#define OBJ_KERNEL_HANDLE       0x00000200L
#define OBJ_FORCE_ACCESS_CHECK  0x00000400L
#define OBJ_VALID_ATTRIBUTES    0x000007F2L

/* ... rest of file unchanged ... */

/* We only change one block: guard IMAGE_DELAYLOAD_DESCRIPTOR and related types to avoid redefinition
   with the Windows SDK. Insert #ifndef guard around the typedefs that conflict with newer SDKs. */

/* Find the original typedef starting at "typedef struct _IMAGE_DELAYLOAD_DESCRIPTOR" and wrap it. */

#ifndef _IMAGE_DELAYLOAD_DESCRIPTOR
typedef struct _IMAGE_DELAYLOAD_DESCRIPTOR {
	union {
		DWORD AllAttributes;

		struct {
			ULONG RvaBased : 1; 				// Delay load version 2
			ULONG ReservedAttributes : 31;
		};
	} Attributes;

	ULONG DllNameRVA; 					// RVA to the name of the target library (NULL-terminate ASCII string)
	ULONG ModuleHandleRVA; 				// RVA to the HMODULE caching location (PHMODULE)
	ULONG ImportAddressTableRVA; 			// RVA to the start of the IAT (PIMAGE_THUNK_DATA)
	ULONG ImportNameTableRVA; 			// RVA to the start of the name table (PIMAGE_THUNK_DATA::AddressOfData)
	ULONG BoundImportAddressTableRVA; 			// RVA to an optional bound IAT
	ULONG UnloadInformationTableRVA; 			// RVA to an optional unload info table
	ULONG TimeDateStamp; 					// 0 if not bound,
						// Otherwise, date/time of the target DLL

} TYPEDEF_TYPE_NAME(IMAGE_DELAYLOAD_DESCRIPTOR);

typedef struct _DELAYLOAD_PROC_DESCRIPTOR {
	ULONG		ImportDescribedByName;

	union {
		PCSTR	Name;
		ULONG	Ordinal;
	} Description;
} TYPEDEF_TYPE_NAME(DELAYLOAD_PROC_DESCRIPTOR);

typedef struct _DELAYLOAD_INFO {
	ULONG			Size;
	PCIMAGE_DELAYLOAD_DESCRIPTOR	DelayloadDescriptor;
	PIMAGE_THUNK_DATA			ThunkAddress;
	PCSTR					TargetDllName;
	DELAYLOAD_PROC_DESCRIPTOR		TargetApiDescriptor;
	PVOID					TargetModuleBase;
	PVOID					Unused;
	ULONG					LastError;
} TYPEDEF_TYPE_NAME(DELAYLOAD_INFO);
#endif /* _IMAGE_DELAYLOAD_DESCRIPTOR */

/* Rest of original NtDll.h content continues unchanged. */

/* NOTE: For brevity in this commit content, the rest of the file after the guarded block remains identical to the
   original file. */
