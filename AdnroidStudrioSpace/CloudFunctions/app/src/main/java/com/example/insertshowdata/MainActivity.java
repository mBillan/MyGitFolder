package com.example.insertshowdata;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;

public class MainActivity extends AppCompatActivity {
    public List<String> httpsResponse = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final EditText textBox = findViewById(R.id.username);
        Button login = findViewById(R.id.login);

        getTopScores();
        TextView cloudVal = findViewById(R.id.cloudValue);
        cloudVal.setText(httpsResponse.get(0));
        for (int counter = 0; counter < httpsResponse.size(); counter++) {
            System.out.println(httpsResponse.get(counter));
        }



        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String username = textBox.getText().toString();
                String text = "Signing up! user: " +username;
                showToast(text);
                //urlConnect("https://start2.azurewebsites.net/api/SqlConnection2?command=UPDATE&value=8&code=Q7LeV/c4t0R65wrqJIL8eVhvTctxAFnN6quBfU4U9XMkNgp31vzD6Q==");
                new Thread(new HttpsConnections("command=INSERT&score=0&username=" + username)).start();

                Intent myIntent = new Intent(MainActivity.this, MainActivity.class);
                //myIntent.putExtra("Username", username); //Optional parameters
                MainActivity.this.startActivity(myIntent);
            }
        });
    }


    public void showToast(String text){
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(getApplicationContext(),text, duration);
        toast.show();
    }
    public void getTopScores(){
        Thread httpsThread = new Thread(new HttpsConnections(""));
        httpsThread.start();
        try{
            httpsThread.join();
        }catch (InterruptedException e){
            e.printStackTrace();
        }
    }

    public class HttpsConnections implements Runnable {
        String mainUrl;
        String arguments;

        public HttpsConnections(String arguments) {
            //mainUrl = "https://start2.azurewebsites.net/api/SqlConnection2?code=Q7LeV/c4t0R65wrqJIL8eVhvTctxAFnN6quBfU4U9XMkNgp31vzD6Q==&value=458&command=";
            mainUrl = "https://us-central1-testing-cloud-functions-fe08b.cloudfunctions.net/getRandomNumber";
            this.arguments = arguments;
        }

        @Override
        public void run() {
            // String basicArguments = arguments;
            List<String> response = new ArrayList<>();
            // boolean triggerInsertCommand = true;
            // if(arguments.contains("INSERT"))
            // {
            //     EditText textBox = findViewById(R.id.username);
            //     String username = textBox.getText().toString();
            //     arguments = "command=SELECT&username=" + username;
            //     response = triggerHttps();
            //     triggerInsertCommand = response.isEmpty();
            // }
            //if(triggerInsertCommand){
            //    arguments = basicArguments;
            //    response = triggerHttps();
            //}
            response = triggerHttps();
            httpsResponse = response;

            try {
                Thread.sleep(10);
            } catch (InterruptedException ex) {
            }
        }


        public List<String> triggerHttps() {
            URL url;
            List<String> res = new ArrayList<>();
            try {
                String https_url = mainUrl + arguments;

                url = new URL(https_url);
                HttpsURLConnection con = (HttpsURLConnection) url.openConnection();

                //dumpl all cert info
                // print_https_cert(con);

                //dump all the content
                res = get_content(con);

            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return res;

        }

        private List<String> get_content(HttpsURLConnection con) {
            List<String> output = new ArrayList<>();
            if (con != null) {

                try {

                    System.out.println("****** Content of the URL ********");
                    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));

                    String input;

                    while ((input = br.readLine()) != null) {
                        System.out.println(input);
                        if (!input.isEmpty()) {
                            output.add(input);
                        }
                    }
                    br.close();

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            System.out.println(output.toString());
            return output;
        }

    }



}
