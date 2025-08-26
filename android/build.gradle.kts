buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.1") // Android Gradle Plugin
        classpath("com.google.gms:google-services:4.4.0")  // Firebase Plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: build klasörünü root dışında bir yerde tutmak istersen
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
