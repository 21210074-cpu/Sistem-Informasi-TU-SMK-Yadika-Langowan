<?php
use App\Livewire\Pages\Dashboard;
use Illuminate\Support\Facades\Route;
Route::get('/', function () {
    return view('welcome');
})->name('home');

Route::get('/reset-admin', function () {
    $role = \App\Models\Role::where('name', 'admin')->first();
    \App\Models\User::updateOrCreate(
        ['email' => 'admin@smk.sch.id'],
        [
            'name' => 'Administrator',
            'password' => 'password',
            'email_verified_at' => now(),
            'role_id' => $role?->id,
            'is_active' => true,
        ]
    );
    return 'Admin reset! Login: admin@smk.sch.id / password — HAPUS route ini setelah berhasil login!';
});

// Test route for Livewire debugging
Route::livewire('test-livewire', 'test-livewire')
    ->middleware(['auth', 'verified'])
    ->name('test.livewire');
Route::livewire('dashboard', Dashboard::class)
    ->middleware(['auth', 'verified'])
    ->name('dashboard');
require _DIR_.'/settings.php';
require _DIR_.'/master.php';
require _DIR_.'/employee.php';
require _DIR_.'/student.php';
require _DIR_.'/admin.php';
require _DIR_.'/parent.php';
require _DIR_.'/student-portal.php';
require _DIR_.'/academic.php';
require _DIR_.'/inventory.php';
require _DIR_.'/finance.php';
