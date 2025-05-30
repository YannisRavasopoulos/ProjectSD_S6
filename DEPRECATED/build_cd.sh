sed -i '/^@startuml$/{
a\
skinparam linetype ortho\
skinparam nodesep 100
}' class_diagram.plantuml
