if keys.IS_WORD_GLOSSARY_PRESENT then
    keys.WORD_GLOSSARY_FUNCS.register_author("BookwormKevin", {4,4} )
    keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
        {
            base_obj = "big",
            display_name = "Big",
            text_type = 2,
            author = "BookwormKevin",
            description = [[Makes the object look big.]],
            thumbnail = "text_big",
            display_sprites = {{
                    sprite = "text_big",
                    color = {0,3},
                    sprite_in_root = false
            }}
        },
        {
            base_obj = "fast",
            display_name = "Fast",
            text_type = 2,
            author = "BookwormKevin",
            description = [[When the object moves, it moves twice as much.
It also stacks, so if an object is FAST AND FAST, it moves 3x as fast.]],
            thumbnail = "text_fast"
        },
        {
            base_obj = "heavy",
            display_name = "Heavy",
            text_type = 2,
            author = "BookwormKevin",
            description = [[Used with PUSH or PULL. When the object is pushed or pulled, it takes 2 pushes/pulls to move it.
This property can be stacked, so each HEAVY means one extra push/pull is needed.]],
            thumbnail = "text_heavy"
        },
        {
            base_obj = "alone",
            display_name = "Alone",
            text_type = 2,
            author = "BookwormKevin",
            description = [[The object cannot move onto any other object.
If the object is on something else, it will try to move off of it onto an empty space in the following order:
Forward, Right, Left, Backward]],
            thumbnail = "text_alone"
        },
        {
            base_obj = "friend",
            display_name = "Friend",
            text_type = 2,
            author = "BookwormKevin",
            description = [[The object cannot move onto empty space.
If the object is lonely, it will try to move onto an object that's next to it in the following order:
Forward, Right, Left, Backward]],
            thumbnail = "text_friend"
        },
        {
            base_obj = "helt",
            display_name = "Helt",
            text_type = 2,
            author = "BookwormKevin",
            description = [[The object acts like both HOT and MELT.
However, it does not destroy itself unless it is also HOT or MELT.]],
            thumbnail = "text_helt"
        },
        {
            base_obj = "nou",
            display_name = "No U",
            text_type = 2,
            author = "BookwormKevin",
            description = [[If the object is about to get destroyed, the attacker is destroyed instead]],
            thumbnail = "text_nou"
        },
        {
            base_obj = "blind",
            display_name = "Blind",
            text_type = 2,
            author = "BookwormKevin",
            description = [[When an object is blind, it acts like it cannot see. This results in the following behavior:
- the seeing condition is never true for it.
- When the object is also 3D, the view will be empty
- Follow and Fear will not work for the object
- When the object is also alone/friend and wants to move, it will move straight forward instead of trying to find an open direction]],

        }
    })
end