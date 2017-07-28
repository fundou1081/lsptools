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

/*
color_palette_0_9
color_palette_1_7
color_palette_1_9
color_palette_250_255

default_button
default_dcl_settings
edit12_box
edit32_box
fcf_ebox
fcf_ebox1
fcf_ibut
fcf_ibut1
files_bottomdf
files_topdf
help_button
std_rq_color
text_25
text_part

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

first007:dialog{
    label="7th dialog";
    :row{
        :list_box{
            label="script";
            width=10;
            height=5;
            list="A\nb\nC\nD\nE";
        }
        :boxed_radio_column{
            label="boxed";
            :radio_button{label="111";value="1";}
            :radio_button{label="222";}
            :radio_button{label="333";}
            :text{label="author";}
        }
    }
    spacer_1;
    ok_only;
}

first008:dialog{
    label="8th";
    :row{
        :boxed_column{
            label="switch";
            :toggle{
                label="highlight";
                value="1";
            }
            :toggle{
                label="mirror";
                value="1";
            }
            :toggle{
                label="attr";
                value="0";
            }
        }
        :boxed_column{
            label="environment";
            :edit_box{
                label="auto save";
                value="30";
                edit_width=8;
            }
            :edit_box{
                label="circle";
                value="1000";
                edit_width=8;
            }
        }
    }
    spacer_1;
    ok_only;
}

first009:dialog{
    label="9th";
    :boxed_row{
        label="standard DCL";
        color_palette_1_7;
    }
    :row{
        :image{
            color=1;
            width=12;
            aspect_ratio=0.66;
        }
        :image{
            color=2;
            width=12;
            aspect_ratio=0.66;
        }
    }
    spacer_1;
    ok_only;
}

first010:dialog{
    label="10th";

    :boxed_row{
        label="Aperture";

        :column{
            spacer_0;
            :text{
                label="Min<<1-20>>Max";
                alignment=centered;
            }
            :slider{
                min_value=1;
                max_value=20;
                width=20;
                height=1;
                small_increment=1;
                big_increment=4;
            }
        }
        :image{
            height=4;
            width=8;
            color=0;
        }

    }

    spacer_1;
    ok_cancel;

}