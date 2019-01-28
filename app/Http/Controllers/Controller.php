<?php

namespace App\Http\Controllers;

use App\Models\Message;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function home(){
        
        if(app()->environment('local')){
            $messages = Message::all();
        } else{
            $messages = [];
        }

        return view('welcome', compact('messages'));
    }
}
