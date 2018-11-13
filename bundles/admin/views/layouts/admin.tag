<admin-layout>

  <div class="eden-admin">
    <div class="eden-admin-navbar">
      <nav class="navbar navbar-sm navbar-expand-md navbar-dark">
        <div class="eden-admin-logo">
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <a class="navbar-brand d-md-block text-center" href="/">
            <i class="fa fa-admin" />
          </a>
        </div>
        <main class="eden-admin-nav">
          <div class="collapse navbar-collapse" id="navbar-nav">
            
            <ul class="navbar-nav flex-row ml-auto mr-lg-0">
              <li class="nav-item">
                <a class="nav-link pr-2" href="/search">
                  <i class="fa fa-search" />
                </a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle mr-3 mr-lg-0" id="admin-user-dropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                  <i class="fa fa-user mr-2" />
                  { this.user.get('username') }
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="admin-user-dropdown">
                  <a class="dropdown-item" href="/admin/user/{ this.user.get('id') }/update">
                    My Account
                  </a>
                  <a class="dropdown-item" href="/logout">
                    Logout
                  </a>
                </div>
              </li>
            </ul>
            
          </div>
        </main>
      </nav>
    </div>
    <aside class="eden-admin-aside">
      <menu name="ADMIN" base="/admin" classes={ this.adminMenuClass } />
    </aside>
    <main class="eden-admin-main">
      <div data-is={ this.view } opts={ this.state } ref="page" class="main-page" />
    </main>
  </div>

  <toast />

  <script>
    // Add mixins
    this.mixin('user');
    this.mixin('config');
    this.mixin('layout');

    // Set menu class object
    this.menuClass = {
      'main' : 'navbar-nav'
    };

    // Set admin menu class object
    this.adminMenuClass = {
      'main' : 'nav nav-pills flex-column',
      'item' : 'nav-item',
      'link' : 'nav-link'
    };
  </script>
</admin-layout>
