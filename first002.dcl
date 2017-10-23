/*
DCL 属性

action="(sub_kk)";
alignment   left    right   centered

allow_accept
aspect_ratio
big_increment
children_alignment
children_fixed_height
chilfren_fixed_width
color
edit_limit
edit_width
fixed_height
fixed_width
fixed_width_font
height
initail_focus
is_bold
is_cancel
is_default
is_enabled
is_tab_stop
key
layout  horizontal  vertical
lable
list
max_value
min_value
mnemonic
multiple_select
password_char
samll_increment
tabs
tab_truncate
value
width

*/

/*
load_dialog
unload_dialog
new_dialog
start_dialog
done_dialog
term_dialog

action_tile

mode_tile
set_tile
get_tile
get_attr

start_list
add_list
end_list

start_image
dimx_tile
dimy_tile
vector_image
fill_image
slide_image
end_image



*/

first002:dialog{
    label="Input dialog";
    :text{
        label="New one 3";
        alignment=centered;
    }
    :edit_box{
        label="image name";
        edit_width=10;
    }
    :edit_box{
        label="date";
        edit_width=10;
    }
    spacer_1;
    ok_cancel;
}

