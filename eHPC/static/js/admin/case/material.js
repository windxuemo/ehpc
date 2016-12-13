function fold_switch() {
    $(".plupload .plupload_content").toggle();
    $("#uploader .moxie-shim").addClass("hide");
}

function fold_close() {
    location.reload();
}

$(document).ready(function () {
    $("#all-select").click(function () {
        if (this.checked) {
            $("#material-table-body").find("input").each(function () {
                this.checked = true;
            });
        }
        else {
            $("#material-table-body").find("input").each(function () {
                this.checked = false;
            });
        }
    });

    $(".panel-heading .local").click(function() {
        $("#uploader").removeClass("hide");
    });

    // Setup html5 version
    $("#uploader").pluploadQueue({
        // General settings
        runtimes : 'html5,flash,silverlight,html4',
        url : upload_url,
        
        rename : false,
        dragdrop: true,
        
        filters : {
            // Maximum file size
            max_file_size : '512mb',
            // Specify what files to browse for
            mime_types: [
                {title : "Zip files", extensions : "zip,rar"},
                {title : "document files",extensions : "pdf"},
                {title : "code files",extensions : "cpp,c,py,js,html,css,java,json,f"}
            ]
        },

        // Resize images on clientside if we can
        resize: {
            width : 200, 
            height : 200, 
            quality : 90,
            crop: true // crop to exact dimensions
        },


        // Flash settings
        flash_swf_url : "url_for('static',filename='js/plupload/Moxie.swf')",
    
        // Silverlight settings
        silverlight_xap_url : "url_for('static',filename='js/plupload/Moxie.xap')",
        init : {
            FileUploaded: function(up, file, info) {
                // Called when file has finished uploading
                table_obj=$.ajax({
                    url: reload_url,
                    async:false,
                });
                $("#material-table-body")[0].innerHTML=table_obj.responseText;
            },
            Error: function(up, err) {
                alert("文件 "+err.file.name+" 上传失败！\n"+"错误信息："+err.message);
            }
        }
    });
    /****************************************************************************************/
    /*function $(id) {
		return document.getElementById(id);
	}

	var uploader = new plupload.Uploader({
		runtimes : 'html5,flash,silverlight,html4',
		browse_button : 'pickfiles', // you can pass in id...
		container: $('container'), // ... or DOM Element itself
		max_file_size : '10mb',

		// Fake server response here
		// url : '../upload.php',
		url: upload_url,

		flash_swf_url : 'http://rawgithub.com/moxiecode/moxie/master/bin/flash/Moxie.cdn.swf',
		silverlight_xap_url : 'http://rawgithub.com/moxiecode/moxie/master/bin/silverlight/Moxie.cdn.xap',
		filters : [
			{title : "Image files", extensions : "jpg,gif,png"},
			{title : "Zip files", extensions : "zip"}
		],

		init: {
			PostInit: function() {
				$('filelist').innerHTML = '';

				$('uploadfiles').onclick = function() {
					uploader.start();
					return false;
				};
			},

			FilesAdded: function(up, files) {
				plupload.each(files, function(file) {
					$('filelist').innerHTML += '<div id="' + file.id + '">' + file.name + ' (' + plupload.formatSize(file.size) + ') <b></b></div>';
				});
			},

			UploadProgress: function(up, file) {
				$(file.id).getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
			},

			Error: function(up, err) {
				$('console').innerHTML += "\nError #" + err.code + ": " + err.message;
			}
		}
	});

	uploader.init();*/
    /***************************************************************************************/


    $("#del-material-btn").click(function () {
        var array = [];
        $("#material-table-body").find("input").each(function () {
            if (this.checked) {
                $(this).parent().parent().remove();
                array.push($(this).parent().parent().data("material_id"));
            }
        });

        $.ajax({
            type: "post",
            url: url,
            data: {
                op: "del",
                material_id: array
            },
            success: function (data) {
                if(data.status=="success"){
                    $("#file-manage-panel").find("input").prop("checked", false);
                }
                else{
                    alert("删除失败");
                }
            }
        });
    });
});
