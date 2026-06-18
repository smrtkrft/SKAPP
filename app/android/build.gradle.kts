allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Namespace fallback for legacy Flutter plugins that haven't migrated
    // to AGP 8+. Without this, plugins predating AGP 8 fail with
    // "Namespace not specified" before any code compiles. Derives a
    // safe stub namespace from the project name so the plugin's stub
    // R class lands somewhere unique. Newer plugins always set
    // namespace explicitly so this branch is a no-op for them.
    plugins.withId("com.android.library") {
        val androidExt = extensions.getByName("android")
        if (androidExt is com.android.build.gradle.LibraryExtension &&
            androidExt.namespace.isNullOrEmpty()) {
            androidExt.namespace =
                "com.skapp.patched.${project.name.replace('-', '_')}"
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
