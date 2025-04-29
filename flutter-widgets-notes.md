# Flutter Widgets Notes

## Layout

In the simplest example, the layout conversation looks like this:

1. A widget receives its constraints from its parent.
2. A constraint is just a set of 4 doubles: a minimum and maximum width, and a minimum and maximum height.
3. The widget determines what size it should be within those constraints, and passes its width and height back to the parent.
4. The parent looks at the size it wants to be and how it should be aligned, and sets the widget's position accordingly. Alignment can be set explicitly, using a variety of widgets like Center, and the alignment properties on Row and Column.

In Flutter, this layout conversation is often expressed with the simplified phrase, "Constraints go down. Sizes go up. Parent sets the position."
