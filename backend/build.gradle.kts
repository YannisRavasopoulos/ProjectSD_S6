plugins {
	kotlin("jvm") version "1.9.25"
	kotlin("plugin.spring") version "1.9.25"
	id("org.springframework.boot") version "3.4.4"
	id("io.spring.dependency-management") version "1.1.7"
	id("com.netflix.dgs.codegen") version "7.0.3"
}

group = "app.loop"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(21)
	}
}

configurations {
	compileOnly {
		extendsFrom(configurations.annotationProcessor.get())
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	compileOnly("org.projectlombok:lombok")
	developmentOnly("org.springframework.boot:spring-boot-devtools")
	developmentOnly("org.springframework.boot:spring-boot-docker-compose")
	annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")
	annotationProcessor("org.projectlombok:lombok")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

kotlin {
	compilerOptions {
		freeCompilerArgs.addAll("-Xjsr305=strict")
	}
}

tasks.generateJava {
	schemaPaths.add("${projectDir}/src/main/resources/graphql-client")
	packageName = "app.loop.backend.codegen"
	generateClient = true
}

tasks.withType<Test> {
	useJUnitPlatform()
}
