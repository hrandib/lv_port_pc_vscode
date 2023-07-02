import qbs

Product {
    name: "lvgl"

    Depends { name: 'cpp' }
    Depends { name: 'config' }

    Export {
        Depends { name: 'cpp' }

        cpp.includePaths: [
            project.LV_PATH
        ]

        Group {
            name: "lvgl_src"
            prefix: project.LV_PATH
            files: [
                "lvgl.h",
                "src/**/*.h",
                "src/**/*.c"
            ]
        }
    }
}

