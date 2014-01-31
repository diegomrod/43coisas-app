<?php
/**
 * Template da aplicação 43coisas do site
 */
 
 global $current_user;
 get_currentuserinfo();
 
 ?>
 <div id="43coisas-content">
  <div>
    <div id="43coisas-wrapper" class="wrapper">
      <div>
          <table>
            <tr>
              <td>
                <h1>43 Coisas - que não deveriam existir!</h1>
              </td>
            </tr>
            <?php for ($i = 1; $i < 4; $i += 1) {?>
              <tr>
                <td>
                  <form method="POST" class="43coisas-form">
                    <?php if ($current_user->user_login) :?>
                      <input name="user" type="hidden" value="<?php echo $current_user->user_login;?>">
                    <?php endif;?>
                    <span>Coisa <?php echo $i; ?> : </span>
                    <input name="coisa" type="text"/>
                  </form>
                </td>
              </tr>
            <?php }?>
            <tr>
              <td>
                <input id="43coisas-button" type="button" value="Enviar">
              </td>
            </tr>
          </table>
      </div>
      <div id="43coisas-coisas">
        <div style="font-size: 12px;">
        </div>
      </div>
    </div>
  </div>
 </div>
