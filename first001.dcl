/*group
button
edit_box
image_button
list_box
popup_list
radio_button
slider
toggle
*/

/*group beauty
icon_image
image
spacer
text
text_part
*/

/*group layout
column
boxed_column
radio_column
boxed_radio_column
row
boxed_row
radio_row
boxed_radio_row
concatenation
paragraph
*/

/*group default
errtile
ok_only
ok_cancel
ok_cancel_help
ok_cancel_err
spacer_0
spacer_1
*/




first001:dialog{
    label="first DCL dialog";
    :text{
        label="New one";
    }
    ok_only;
}

first002:dialog{
    label="Second DCL dialog";
    spacer_1;
    :text{
        label="New one 2";
        alignment=centered;
    }
    spacer_1;
    ok_only;    
}

first003:dialog{
    label="Third DCL dialog";
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

first004:dialog{
    label="4th DCL dialog";
    :text{
        label="New one 3";
        alignment=centered;
    }
    :row{
        :edit_box{
            label="image name";
            edit_width=10;
        }
        :edit_box{
            label="date";
            edit_width=10;
        }
    }
    spacer_1;
    ok_cancel;
}

first005:dialog{
    label="5th DCL";
    :text{
        label="5th";
        alignment=centered;
    }
    :row{
        :edit_box{label="image";    edit_width=10;}
        :edit_box{label="date";     edit_width=10;}
    }
    :boxed_radio_row{
        label="outline";
        :radio_button{label="A";}
        :radio_button{label="B";}
        :radio_button{label="C";value="1";}
    }
    spacer_1;
    ok_cancel;
}

first006:dialog{
    label="6th DCL";
    :text{
        label="5th";
        alignment=centered;
    }
    :row{
        :edit_box{label="image";    edit_width=10;}
        :edit_box{label="date";     edit_width=10;}
    }
    :boxed_radio_row{
        label="outline";
        :radio_button{label="A";}
        :radio_button{label="B";}
        :radio_button{label="C";value="1";}
    }
    :boxed_row{
        label="setup";
        :popup_list{
            label="ratio";
            edit_width=8;
            list="1:1\n1:10\n1:20\n1:50\n1:100\n1:200";
        }
        :popup_list{
            lable="point";
            edit_width=12;
            list="0\n0.0\n0.00\n0.000\n";
        }
    }
    spacer_1;
    ok_cancel;
}