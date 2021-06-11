<?php

namespace App\Http\Livewire;

use Livewire\Component;

class AddServer extends Component
{
    public function addNewServer()
    {

        //To do:
        // Create new DO server
        // Wait for the server to be ready
        // Do the setup on the server
        // Add the new server to the syntropy network and allow the connections
        // Get the IP and the name and update the config.yaml
        // Restart the proxy
        // show some logs/output to the user

        // $process = new Process(['bash', base_path().'/infrastructure/add.sh']);
        // $process->run();

        // $this->servers = $process->getOutput();
    }

    public function render()
    {
        return view('livewire.add-server');
    }
}
