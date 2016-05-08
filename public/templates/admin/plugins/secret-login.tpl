<form id="secret-login">
    <div class="row">
        <div class="col-lg-9">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <div class="panel-title">
                        Secret Login Plugin Settings
                    </div>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="control-label" for="username">
                            Username To Log In
                        </label>
                        <input type="text" class="form-control" data-key="username" id="username" placeholder="username"></input>
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="key">
                            Secret:
                        </label>
                        <input type="text" class="form-control" data-key="secret" id="secret" placeholder="some_random_characters"></input>
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="secreturl">
                            Secret URL:
                        </label>
                        <a href="" id="secreturl" target="_blank"></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    Action Panel
                </div>
                <div class="panel-body">
                    <button type="button" class="btn btn-success form-control" accesskey="s" id="save">
                        <i class="fa fa-fw fa-save"></i> Save Settings
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
require(['settings'], function(settings) {
    var $username = $('[data-key="username"]');
    var $secret = $('[data-key="secret"]');
    settings.sync('secret-login', $('#secret-login'));
    $('#save').click( function (event) {
        settings.persist('secret-login', $('#secret-login'), function(){
            socket.emit('admin.settings.syncSecretLogin', {}, function(err, data){
            // Refresh key.
            $key.val(data.key);
          });
        });
    });

    var resync = function() {
	    $("#secreturl").attr("href", "/secret-login?secret=" + encodeURIComponent($secret.val()));
    };
    $secret.keypress(resync);
    $secret.keyup(resync);
    $secret.change(resync);
});
</script>
