<?php

use App\Models\Message;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        Message::create([
            'author' => 'Peter Mein',
            'message' => 'We\'re running in docker!'
        ]);
    }
}
