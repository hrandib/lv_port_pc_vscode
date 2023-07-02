import qbs
import qbs.FileInfo

Project {
    name: "lvgl_simulator"
    references: [
        "lvgl.qbs",
    ]

    property string SRC_MCU: sourceDirectory + "/ui/source/"
    property string LV_PATH: SRC_MCU + "/lvgl/"

    Product {
        name: "config"
        Depends { name: "cpp" }

        Export {
            Depends { name: "cpp" }

            cpp.commonCompilerFlags: [
                "-fdata-sections",
                "-ffunction-sections",
                "-flto=auto", "-ffat-lto-objects",
            ]

            cpp.cxxFlags: [
                "-Wno-register",
                "-Wno-volatile",
                "-Wno-deprecated-enum-enum-conversion",
                "-fconcepts-diagnostics-depth=2"
            ]

            cpp.cLanguageVersion: "gnu17"
            cpp.cxxLanguageVersion: "gnu++23"

            cpp.defines: [
                "SIMULATOR=1",
                "LV_BUILD_TEST=0",
                "LV_LVGL_H_INCLUDE_SIMPLE",
                "USE_MOUSE=0",
                "USE_MOUSEWHEEL=0",
            ]

            cpp.linkerFlags: [
                "--gc-sections",
            ]

            cpp.positionIndependentCode: true
            cpp.enableExceptions: false
            cpp.enableRtti: false

            Properties {
                condition: qbs.buildVariant === "release"
                cpp.debugInformation: false
                cpp.optimization: "fast"
            }

            Properties {
                condition: qbs.buildVariant !== "release"
                cpp.debugInformation: true
                // cpp.generateLinkerMapFile: true
                cpp.commonCompilerFlags: [ "-Og" ]
            }
        }
    }

    CppApplication {

        Depends { name: "config" }
        Depends { name: "lvgl" }

        consoleApplication: true

        cpp.dynamicLibraries: ["m", "SDL2"]

        cpp.includePaths: [
            sourceDirectory,
            project.SRC_MCU + "resource",
            project.SRC_MCU + "ui",
            project.SRC_MCU + "utility",
        ]

        Group {
            name: "main"
            prefix: "main/src/"
            files: [
                "main.cpp",
            ]
        }

        Group {
            name: "ui"
            prefix: project.SRC_MCU + "ui/"
            files: [
                "main_screen.cpp",
                "ui.h",
            ]
        }

        Group {
            name: "utility"
            prefix: project.SRC_MCU + "utility/"
            files: [
                "gfx_font_renderer.cpp",
                "gfx_font_renderer.h",
            ]
        }

        Group {
            name: "drivers"
            prefix: "lv_drivers/"
            files: [
                "display/monitor.c",
                "display/monitor.h",
                "indev/keyboard.c",
                "indev/keyboard.h",
            ]
            cpp.includePaths: outer.concat([
                "lv_drivers/display",
                "lv_drivers/indev",
            ])
        }

        Group {
            name: "fonts"
            prefix: project.SRC_MCU
            files: [
                "resource/monofonts.h",
                "resource/monofonts.cpp",
                "resource/hooge_mono_50px.c",
                "SSD1306Ascii/src/fonts/font5x7.h",
            ]
            cpp.includePaths: outer.concat([
                project.SRC_MCU + "/SSD1306Ascii/src/fonts"
            ])
        }

    } //CppApplication

} //Project
